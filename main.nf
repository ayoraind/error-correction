#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// include definitions
include  { helpMessage; Version } from './modules/messages.nf'

// include processes
include { MEDAKA_FIRST_ITERATION; MEDAKA_SECOND_ITERATION_FOR_FLYE_ASSEMBLY; MEDAKA_SECOND_ITERATION_FOR_SBERRY_ASSEMBLY } from './modules/processes.nf'

log.info """\
    ERROR CORRECTION  - TAPIR P I P E L I N E
    ==========================================
    output_dir       : ${params.output_dir}
    """
    .stripIndent()


workflow  {
          read_ch = channel
                          .fromPath( params.reads, checkIfExists: true )
                          .map { file -> tuple(file.simpleName, file) }

          assemblies_ch = channel
                                .fromPath( params.assemblies, checkIfExists: true )
                                .map { file -> tuple(file.simpleName, file) }

         joined_ch = read_ch.join(assemblies_ch)



         MEDAKA_FIRST_ITERATION(joined_ch)

         joined_final_ch = read_ch.join(MEDAKA_FIRST_ITERATION.out.first_iteration_ch)

         if (params.sberry) {

                MEDAKA_SECOND_ITERATION_FOR_SBERRY_ASSEMBLIES(joined_final_ch)
         }

         else {
                MEDAKA_SECOND_ITERATION_FOR_FLYE_ASSEMBLIES(joined_final_ch)

         }

         // the short way instead of the 'if'  statementwould have been the code below. However, I didn't test this
         // (params.sberry ? MEDAKA_SECOND_ITERATION_FOR_SBERRY_ASSEMBLIES(joined_final_ch) : MEDAKA_SECOND_ITERATION_FOR_FLYE_ASSEMBLIES(joined_final_ch) )
}
