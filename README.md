# RBLX-Whitelist
Source repo for my series on writing secure Authentication systems in Roblox  
- To read the guide, visit my [website](https://shiawase.dev/blog/rblx-auth1)

## Flowchart

<details>
  <summary>Image Version</summary>

![flowchart](/assets/FlowchartDiagram.png)

</details>

<details>
  <summary>Mermaid (interactive) Version</summary>

```mermaid
graph TD;
    A[User executes script] --> B[Client prepares environment]
    B --> C[Check for irregularities in the client for early detection]
    C -- Found irregularities --> D[Stop code execution & exit environment]
    C -- No irregularities found --> E[Preparation steps]
    E --> |HTTP Request Function| E1
    E --> |Randomized numbers| E2
    E --> |User authentication key| E3
    E --> F{Perform auth request}
    E -- Incomplete items --> D
    
    F --> |Send request| G[Server receives]
    G --> |User authentication key| G1
    G --> |User fingerprint via Headers| G2
    G --> |Arithmetically modified numbers| G3
    
    G --> H[Perform authentication Checks]
    H --> I{Conditions to check}
    I --> |Is user key valid?| J
    I --> |Is user's fingerprint stored?| K
    I --> |Is request legitimate?| L
    
    J & K & L -- Valid Conditions --> M[Server returns successful response]
    J & K & L -- Invalid Conditions --> N[Return invalid response]
    N --> D
    
    M --> |Necessary Data| O[Process received data]
    O --> P{Conditions to check}
    P --> |Check whitelist indicator| P1
    P --> |Check x * y = y?| P2
    P --> |Use server data for execution| P3
    
    P --> Q[Run Code]
    Q --> R[LPH_ENCFUNC]
    
    subgraph "Data to return"
        M1[Arithmetically modified numbers]
        M2[Whitelist indicator]
        M3[Server-reliant data like LPH_ENCFUNC key]
    end
    M --> M1
    M --> M2
    M --> M3
    
    subgraph "Database Connection"
        H
    end
```
</details>

# License
[MIT](/LICENSE)
