# Mermaid Hello
Mermaid renders nicely ad-hoc in GitHub Markdown on GitHub and in VSCode.  
Better than `PlantUML`, sometimes compatible with `PlantUML`, sometimes just as hideous.

## Graphs
```mermaid
%% Ima comment

%% top-down
graph TB
%% TB - top bottom
%% BT - bottom top
%% RL - right left
%% LR - left right
%% TD - same as TB

API[REST API worker]
DB[(My Database)]
API -->|Reads data,\nWrites data| DB

subgraph "Worker Nodes"
    direction TB  %% apparently, TD does not work in directions
    W1[Worker 1]
    W2[Worker 2]
    Wn[Worker n]
end

X[Node A]:::This_is_a_des
```


## Flowcharts
```mermaid
---
title: Some title, only works with Flowcharts it seems
---
flowchart LR
    id[Ima box]
```