---
layout: page
title: "ETL Prototype Summary Example"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/etl_en/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  <- Back
</a>

# ETL Prototype Summary Example
<br>

## Overview
An ETL prototype that processes large volumes of data in parallel using Spring Batch partitioning. Extract and Load are configured as independent steps, and chunk-based processing and exception-skip strategy were applied to secure both performance and stability.

<br>
## Core Code Example
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

## Core Structure
 - Partitioning-based parallel processing  
 - Chunk-unit data processing  
 - Skip handling on exceptions (prevents total stop)  
 - Listener-based logging and post-processing

<br> 

## Key Points
- Improved large-volume data processing performance (multithreaded)
- Work can continue even when errors occur
- Execution history and status can be tracked
