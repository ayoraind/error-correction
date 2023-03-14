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


process MEDAKA_FIRST_ITERATION {
    tag "error correction of $meta assemblies"
    
    // publishDir "${params.output_dir}", mode:'copy'
    
    // errorStrategy 'ignore'
    
    conda './medaka_env.yml'
    
    input:
    tuple val(meta), path(reads), path(assembly)

    output:
    tuple val(meta), path("${meta}.fasta"), emit: first_iteration_ch
    path "versions.yml"                   , emit: versions_ch

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


process MEDAKA_SECOND_ITERATION {
    tag "error correction of $meta assemblies"
    
    publishDir "${params.output_dir}/${meta}_FLYE_SBERRY_MEDAKA", mode:'copy'
    
    // errorStrategy 'ignore'
    
    conda './medaka_env.yml'
    
    input:
    tuple val(meta), path(reads), path(assembly)

    output:
    tuple val(meta), path("${meta}.fasta"), emit: second_iteration_ch
    path "versions.yml"                   , emit: versions_ch

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


         MEDAKA_FIRST_ITERATION(joined_ch)
	 
	 joined_final_ch = read_ch.join(MEDAKA_FIRST_ITERATION.out.first_iteration_ch)
	 
	 MEDAKA_SECOND_ITERATION(joined_final_ch)
	 
	 

}
