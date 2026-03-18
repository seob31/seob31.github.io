---
layout: page
title: "Reactor 기반 비동기 워크플로우 & Saga 처리 구조"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/etl/
---

<p>
  <a href="/projects/ESB-EAI-eCross/" class="btn btn-outline-success btn-sm">← 뒤로가기</a>
</p>

# Reactor 기반 비동기 워크플로우 & Saga 처리 구조

## 개요
ESB/EAI 시스템에서 마이크로서비스 간 트랜잭션 관리를 위한 Saga Pattern을 적용할 수 있는 구조 기반으로, Reactor를 활용한 비동기 워크플로우를 구현.

## 핵심 코드 예제
### 1. Step 상태 관리 및 비동기 처리
```java
public Step slaveStep(StepBuilderFactory stepBuilderFactory, ReadRequestDto requestDto, DataSourceUtils dataSourceUtils) {
  setDataBaseConfig(dataSourceUtils.getDataSource());

  @SuppressWarnings("unchecked")
  ItemReader<Map<String, Object>> reader = (ItemReader<Map<String, Object>>) context.getBean("extractReader");
  @SuppressWarnings("unchecked")
  ItemWriter<Map<String, Object>> writer = (ItemWriter<Map<String, Object>>) context.getBean("extractWriter");
  @SuppressWarnings("unchecked")
  ItemReadListener<Map<String, Object>> itemReadListener = (ItemReadListener<Map<String, Object>>) context.getBean("extractReadLoggingListener");

  FileWriteAndExecutionItemListener fileWriteAndExecutionItemListener = (FileWriteAndExecutionItemListener) context.getBean("fileWriteAndExecutionItemListener");

  return stepBuilderFactory.get("subStep")
          .<Map<String, Object>, Map<String, Object>>chunk(requestDto.getChunkSize())
          .reader(reader)
          .writer(writer)
          .listener(itemReadListener)
          .faultTolerant()
          .skip(Exception.class)
          .skipLimit(Integer.MAX_VALUE)
          .listener((ItemWriteListener<? super Map<String, Object>>) fileWriteAndExecutionItemListener)
          .listener((StepExecutionListener) fileWriteAndExecutionItemListener)
          .transactionManager(transactionManager)
          .build();
}

@JobScope
public Job createPartitionedJob(ReadRequestDto requestDto) {
    init(requestDto);

    Step masterStep = stepBuilderFactory.get("etlMainStep")
            .partitioner("etlSubStep", dBPartitioner)
            .step(dBExtractStep.slaveStep(stepBuilderFactory, requestDto, dataSourceUtils))
            .gridSize(requestDto.getPartitionSize())
            .taskExecutor(taskExecutor(requestDto.getPartitionSize()))
            .build();

    return jobBuilderFactory.get("partitioned-extract-job-" + System.currentTimeMillis())
            .start(masterStep)
            .listener(cleanupListener())
            .preventRestart()
            .build();
}

@JobScope
public Job createPartitionedJob(WriteRequestDto requestDto) {
    filePartitioner.setFilePath(requestDto.getFilePath());
    fileLoadStep.setDataBaseConfig(DBType.getDataSource(requestDto.getDbType()));

    int fileCount = countPartitionFiles(requestDto.getFilePath());
    this.executor = taskExecutor(fileCount);

    Step masterStep = stepBuilderFactory.get("etlMainStep")
            .partitioner("etlSubStep", filePartitioner)
            .step(fileLoadStep.slaveStep(stepBuilderFactory, requestDto))
            .gridSize(fileCount)
            .taskExecutor(executor)
            .build();

    return jobBuilderFactory.get("partitioned-load-job-" + System.currentTimeMillis())
            .start(masterStep)
            .listener(cleanupListener())
            .build();
}


public Step slaveStep(StepBuilderFactory stepBuilderFactory, WriteRequestDto requestDto) {
    @SuppressWarnings("unchecked")
    ItemReader<Map<String, Object>> reader = (ItemReader<Map<String, Object>>) context.getBean("loadReader");
    @SuppressWarnings("unchecked")
    ItemWriter<Map<String, Object>> writer = (ItemWriter<Map<String, Object>>) context.getBean("loadWriter");
    @SuppressWarnings("unchecked")
    ItemReadListener<Map<String, Object>> itemReadListener = (ItemReadListener<Map<String, Object>>) context.getBean("loadReadLoggingListener");

    SkipAndExecutionItemListener skipAndExecutionItemListener = (SkipAndExecutionItemListener) context.getBean("skipAndExecutionItemListener");

    return stepBuilderFactory.get("subStep")
            .<Map<String, Object>, Map<String, Object>>chunk(requestDto.getChunkSize())
            .reader(reader)
            .writer(writer)
            .listener(itemReadListener)
            .faultTolerant()
            .skip(Exception.class)
            .skipLimit(Integer.MAX_VALUE)
            .listener((SkipListener<? super Map<String, Object>, ? super Map<String, Object>>) skipAndExecutionItemListener)
            .listener((StepExecutionListener) skipAndExecutionItemListener)
            .transactionManager(transactionManager)
            .build();
}

```


## 핵심 포인트
1. **Hub 채널 간 트랜잭션 관리 단순화**
   - ProcessStep 단위로 실행 상태를 관리하여 복잡한 흐름 제어를 단순화
   - 실패 시 skip / 후속 처리 분기를 통해 전체 중단 없이 안정적인 처리 가능

2. **분할 처리 (Split Processing) 지원**
   - 대용량 데이터 처리 시 split 단위로 처리 가능
   - writer/reader 이후 흐름을 구분하여 중복 실행 방지

3. **비동기 워크플로우 처리**
   - WebClient를 활용한 non-blocking 호출 구조

4. **운영 중심 장애 처리**
   - 모니터링에 상태가 기록됨으로 어느 구간에서 장애 발생 파악 가능
