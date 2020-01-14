version 1.0
import "tasks/alignment.wdl" as align
import "tasks/svcalling.wdl" as svcall

workflow grandsv {
    input {
        String project_id
        String sample_id
        File fastq
        String ont_sv_path
        String proj_path = ont_sv_path + "/" + project_id + "/" + sample_id
        File ref
        String ref_version
        String aligner
        String svcaller
        String aligner_docker
        String aligner_mem
        String aligner_cpu
        String svcaller_docker
        String svcaller_mem
        String svcaller_cpu
    }

    call align.alignment as alignment{
        input:
            project_id = project_id,
            sample_id = sample_id,
            fastqFile = fastq,
            ref = ref,
            ref_version = ref_version,
            aligner = aligner,
            align_dir = proj_path + "/" + aligner,
            docker_image = aligner_docker,
            mem_size = aligner_mem,
            num_cpu = aligner_cpu
    }

    call svcall.svcalling as svcalling {
        input:
            project_id = project_id,
            sample_id = sample_id,
            ref_version = ref_version,
            bam = alignment.bam,
            aligner = aligner,
            svcaller = svcaller,
            svcall_dir = proj_path + "/" + svcaller,
            docker_image = svcaller_docker,
            mem_size = svcaller_mem,
            num_cpu = svcaller_cpu
    }
}

