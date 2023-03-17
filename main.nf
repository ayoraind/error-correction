#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// include non-process modules
include { help_message; version_message; complete_message; error_message; pipeline_start_message } from './modules/messages.nf'
include { default_params; check_params } from './modules/params_parser.nf'
include { help_or_version } from './modules/params_utilities.nf'

version = '1.0dev'

// setup default params
default_params = default_params()
// merge defaults with user params
merged_params = default_params + params

// help and version messages
help_or_version(merged_params, version)
final_params = check_params(merged_params)
// starting pipeline
pipeline_start_message(version, final_params)


// include processes
include { MEDAKA_FIRST_ITERATION; MEDAKA_SECOND_ITERATION_FOR_FLYE_ASSEMBLIES; MEDAKA_SECOND_ITERATION_FOR_SBERRY_ASSEMBLIES } from './modules/processes.nf' addParams(final_params)


workflow  {
          read_ch = channel
                          .fromPath( final_params.reads, checkIfExists: true )
                          .map { file -> tuple(file.simpleName, file) }

          assemblies_ch = channel
                                .fromPath( final_params.assemblies, checkIfExists: true )
                                .map { file -> tuple(file.simpleName, file) }

         joined_ch = read_ch.join(assemblies_ch)



         MEDAKA_FIRST_ITERATION(joined_ch)

         joined_final_ch = read_ch.join(MEDAKA_FIRST_ITERATION.out.first_iteration_ch)

         if (final_params.sberry) {

                MEDAKA_SECOND_ITERATION_FOR_SBERRY_ASSEMBLIES(joined_final_ch)
         }

         else {
                MEDAKA_SECOND_ITERATION_FOR_FLYE_ASSEMBLIES(joined_final_ch)

         }

         // the short way instead of the 'if'  statementwould have been the code below. However, I didn't test this
         // (params.sberry ? MEDAKA_SECOND_ITERATION_FOR_SBERRY_ASSEMBLIES(joined_final_ch) : MEDAKA_SECOND_ITERATION_FOR_FLYE_ASSEMBLIES(joined_final_ch) )
}
