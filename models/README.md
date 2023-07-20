# Models

The model directory stores model files for all Stock Synthesis runs. The sub-directory structure will include a single directory for each year. Inside of these year directories, there will be directories that store sets of models. A model set will include a base model directory, a sensitivity model directory, and a bridging model directory that maps the path from the previous year to the base model. The base directory within a set is the only directory that 

## Example directory structure

```
├── 2021
│   ├── base
│   │   └── base
│   └── exploration
├── 2023
│   ├── base
│   │   ├── base
│   │   │   ├── data.ss
│   │   │   ├── control.ss
│   │   │   ├── forecast.ss
│   │   │   ├── starter.ss
│   │   ├── bridging
│   │   │   ├── 01_UpperCamelCase
│   │   │   ├── 02_IDidThisThing
│   │   │   ├── 03_UpdatedCatches
│   │   │   └── ...
│   │   ├── sensitivities
│   │   │   ├── 01_Jitter
│   │   │   ├── 02-a_LowerM
│   │   │   ├── 02-b_UpperM
│   │   │   └── 03_NewSet
│   │   ├── sandbox
│   │   │   ├── 01_RandomExploration
│   │   │   ├── 02-a_ChangeSelectivity
│   │   │   ├── 02-b_ChangeSelectivityFromA
│   │   │   └── 03_New
│   ├── run.R
└── README.md
```

## Directory naming rules

Sub-directories inside of bridging and sensitivities should start with two integers. These integers will dictate the visual order of the directories. Additional dashes and text between the dashes can follow to delineate groups within a digit category. Then, an underscore will separate the group from the description. Descriptions should be written in UpperCamelCase. The entire sub-directory name looks like `[0-9][0-9]-group_LongDescription`. For example, `01-Jitter` is the first sensitivity that should be ran because if you find a different answer for your base model you would not have wanted to already ran all of your other sensitivities. Group delineations can be left off.
