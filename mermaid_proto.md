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

A1[Rectangle]
A2(Rounded)
A3((Circle))
A4[(Database)]
A5([Strong Rounded])
A6{Rombus}
A7{{Long Diamond}}

B1["Wrap stuff in parentheses (if necessary)"]

subgraph W[Worker Nodes]
    direction TB  %% apparently, TD does not work in directions
    W1[Worker 1]
    W2[Worker 2]
    Wn[Worker n]
end

N1[Node 1]:::This_is_a_description_dont_know_what_its_good_for
N2[Node 2]
N3[Node 3]
N4[Node 4]
N5[Node 5]
N6[Node 6]

N1 --> N2
N2 <--> N3
N3 ---> N4
N3 ---> N4
N3 ---> N4
N4 -..-> N5
N5 ...-> N6
```


## Flowcharts
```mermaid
---
title: Some title, only works with Flowcharts it seems
---
flowchart LR
    id[Ima box]
```
