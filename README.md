## Workflow to correct errors in long read assemblies.
### Usage

```

===================================================================
 ERROR CORRECTION: TAPIR Pipeline version 1.0dev
===================================================================
 The typical command for running the pipeline is as follows:
        nextflow run main.nf --reads "PathToReadFile(s)" --assemblies "PathToFastaFiles" --output_dir "PathToOutputDir" 

        Mandatory arguments:
         --reads                        Query fastq.gz file of sequences you wish to supply as input (e.g., "/MIGE/01_DATA/01_FASTQ/T055-8-*.fastq.gz")
	 --assemblies			Query fasta file(s). Should be assemblies derived from Flye or Strainberry (e.g., /MIGE/01_DATA/03_ASSEMBLY/*_FLYE/*.fasta or /MIGE/01_DATA/03_ASSEMBLY/*_FLYE_SBERRY/*.fasta).
         --output_dir                   Output directory (e.g., "/MIGE/01_DATA/03_ASSEMBLY")
         
        Optional arguments:
	 --sberry			For error-correction of strain-resolved (from Strainberry) assemblies (Default: False). If true, simply supply --sberry as part of the arguments
         --help                         This usage statement.
         --version                      Version statement

```


## Introduction
This pipeline error corrects assemblies using [Medaka](https://github.com/nanoporetech/medaka). This Nextflow pipeline was adapted from NF Core's [Medaka module](https://github.com/nf-core/modules/tree/master/modules/nf-core/medaka).  


## Sample command
An example of a command to run this pipeline is:

```
nextflow run main.nf --reads "Sample_files/*.fastq.gz" --assemblies "Sample_files/*.fasta" --output_dir "test" 
```

## Word of Note
This is an ongoing project at the Microbial Genome Analysis Group, Institute for Infection Prevention and Hospital Epidemiology, Üniversitätsklinikum, Freiburg. The project is funded by BMBF, Germany, and is led by [Dr. Sandra Reuter](https://www.uniklinik-freiburg.de/institute-for-infection-prevention-and-control/microbial-genome-analysis.html).


## Authors and acknowledgment
The TAPIR (Track Acquisition of Pathogens In Real-time) team.
