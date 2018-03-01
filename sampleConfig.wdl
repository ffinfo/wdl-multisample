task SampleConfig {
    File jar
    Array[File]+ inputFiles
    String? sample
    String? library
    String? readgroup
    String? jsonOutputPath
    String? tsvOutputPath

    command {
        mkdir -p . $(dirname ${jsonOutputPath}) $(dirname ${tsvOutputPath})
        java -jar ${jar} \
        -i ${sep="-i " inputFiles} \
        ${"--sample " + sample} \
        ${"--library " + library} \
        ${"--readgroup " + readgroup} \
        ${"--jsonOutput " + jsonOutputPath} \
        ${"--tsvOutput " + tsvOutputPath}
    }

    output {
        Array[String] keys = read_lines(stdout())
        File? jsonOutput = jsonOutputPath
        File? tsvOutput = tsvOutputPath
        Object values = if (defined(tsvOutput) && size(tsvOutput) > 0) then read_map(tsvOutput) else { "": "" }
    }
}

task DownloadSampleConfig {
    String? version = "0.1"

    command {
        wget https://github.com/biopet/sampleconfig/releases/download/v${version}/SampleConfig-assembly-${version}.jar
    }

    output {
        File jar = "SampleConfig-assembly-" + version + ".jar"
    }
}