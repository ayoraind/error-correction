def helpMessage() {
  log.info """
        Usage:
        The typical command for running the pipeline is as follows:
        nextflow run main.nf --reads "PathToReadFile(s)" --output_dir "PathToOutputDir" --assemblies "PathToFastas" 

        Mandatory arguments:
         --reads                        Query fastq.gz file of sequences you wish to supply as input (e.g., "/MIGE/01_DATA/01_FASTQ/T055-8-*.fastq.gz")
         --output_dir                   Output directory to place final combined kraken output (e.g., "/MIGE/01_DATA/03_ASSEMBLY")
         --assemblies	                Filepath to the assembly file

        Optional arguments:
         --help                         This usage statement.
         --version                      Version statement
        """
}

version = '1.0dev'

def Version() {
      println(
            """
            ====================================================
             ERROR CORRECTION TAPIR Pipeline version ${version}
            ====================================================
            """.stripIndent()
        )

}


// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

// Show version
if (params.version) {
    Version()
    exit 0
}


