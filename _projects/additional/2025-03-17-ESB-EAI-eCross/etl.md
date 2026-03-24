---
layout: page
title: "ETL 프로토타입 정리 예시"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/etl/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  ← 뒤로가기
</a>

# ETL 프로토타입 정리 예시
<br>

## 개요
Spring Batch의 Partitioning 구조를 활용하여 대용량 데이터를 병렬로 처리하는 ETL 프로토타입. Extract와 Load를 각각 독립적인 Step으로 구성하고, chunk 기반 처리와 예외 skip 전략을 적용하여 성능과 안정성을 동시에 확보.

<br>
## 핵심 코드 예제
#### Extract Step
```java
public Step slaveStep(StepBuilderFactory stepBuilderFactory, ReadRequestDto requestDto, DataSourceUtils dataSourceUtils) {
  setDataBaseConfig(dataSourceUtils.getDataSource());

  @SuppressWarnings("unchecked")
  ItemReader<Map<String, Object>> reader = (ItemReader<Map<String, Object>>) context.getBean("extractReader");
  @SuppressWarnings("unchecked")
  ItemWriter<Map<String, Object>> writer = (ItemWriter<Map<String, Object>>) context.getBean("extractWriter");
  @SuppressWarnings("unchecked")
  ItemReadListener<Map<String, Object>> itemReadListener = (ItemReadListener<Map<String, Object>>) context.getBean("extractReadLoggingListener");

  FileWriteAndExecutionItemListener fileWriteAndExecutionItemListener =
      (FileWriteAndExecutionItemListener) context.getBean("fileWriteAndExecutionItemListener");

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
```
<br>

#### Load Step
```java
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
    ItemReadListener<Map<String, Object>> itemReadListener =
        (ItemReadListener<Map<String, Object>>) context.getBean("loadReadLoggingListener");

    SkipAndExecutionItemListener skipAndExecutionItemListener =
        (SkipAndExecutionItemListener) context.getBean("skipAndExecutionItemListener");

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
<br>

## 핵심 구조  
 - Partitioning 기반 병렬 처리  
 - Chunk 단위 데이터 처리  
 - 예외 발생 시 skip 처리 (전체 중단 방지)  
 - Listener 기반 로깅 및 후처리  

<br> 

## 핵심 포인트
- 대용량 데이터 처리 성능 향상 (멀티스레드)
- 장애 발생 시에도 작업 지속 가능
- 실행 이력 및 상태 추적 가능
