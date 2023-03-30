/*
 * pipeline input parameters
 */
params.assemblies = "$projectDir/data/ggal/gut.fasta"

params.reads = "$projectDir/data/ggal/gut_{1,2}.fastq"
params.output_dir = "$PWD/results"
nextflow.enable.dsl=2


log.info """\
    ERROR CORRECTION  - TAPIR   P I P E L I N E
    ============================================
    output_dir       : ${params.output_dir}
    """
    .stripIndent()

/*
 * define the `index` process that creates a binary index
 * given the transcriptome file
 */


process MEDAKA {
    tag "error correction of $meta assemblies"
    
    publishDir "${params.output_dir}", mode:'copy'
    
    conda './env.yml'
    
    input:
    tuple val(meta), path(reads), path(assembly)

    output:
    tuple val(meta), path("${meta}.fasta"), emit: first_assembly_ch
    path "versions.yml"             , emit: versions_ch

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta}"
    """
    medaka_consensus -t $task.cpus $args -i $reads -d $assembly -m r941_min_hac_g507 -o .
    
    mv consensus.fasta ${prefix}.fasta
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        medaka: \$( medaka --version 2>&1 | sed 's/medaka //g' )
    END_VERSIONS
    """
}

workflow  {
          read_ch = channel
                          .fromPath( params.reads, checkIfExists: true )
                          .map { file -> tuple(file.simpleName, file) }
			  
	  assemblies_ch = channel
                                .fromPath( params.assemblies, checkIfExists: true )
				.map { file -> tuple(file.simpleName, file) }
				
	 joined_ch = read_ch.join(assemblies_ch)
	// joined_ch.view()


         MEDAKA(joined_ch)

}
