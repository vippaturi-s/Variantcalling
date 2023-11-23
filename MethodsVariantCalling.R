---
  author: Sravani Vippaturi
output:
  html_document:
  toc: true
toc_depth: 4
toc_float: true
dev: 'svg'
md_document:
  variant: gfm 
bibliography: bibliography.ris
---
  
  ##Variant Calling
  
  A variant call is the process of identifying variants in sequence data. 
1. Sequences are created by carrying out whole genome or whole exome sequencing. 
2. The sequences are aligned to a reference genome, then BAM files or CRAM files are generated.
3. Align the reads with the reference genome and create VCF files where the read alignments differ.

###getGenome.sh

Using the script Downloaded the reference genome from ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/GRCh38.primary_assembly.genome.fa.gz with the help of WGET command. 

1. If you have a URL, you can use wget to download files. These methods generally work, but they will be slower if your dataset is too large (they utilize HTTP, much like regular web pages).

-o option permits to setup a File name for the referernce genome.

###getReads.sh

Using the scriprt NGS reads have been retreived from the NA12878 reference sample

A tool called fastq-dump can be used for downloading sequencing reads from NCBI's Sequence Read Archive (SRA). These sequence reads will be downloaded as FASTQ files.

--split-files Dump each read into separate file SRR6808334.Files will receive suffix corresponding to read number.

###trimReads.sh

Using Trimmomatic we qulity trim the reads

nice –n 19 is a shell command telling the server to give this a lower priority than critical server functions. 
java -jar commands are used to run java files
`/usr/local/programs/Trimmomatic-0.36/trimmomatic-0.36.jar' is the location of the Java jar file. PE indicates that we have paired-end reads. 
-threads indicates how many server threads to use for this job.
-phred33 indicates the quality encoding method used for the reads. The backslash allows commands to span multiple lines
The next two parameters are left and right read files. 
The next four parameters constitute the output files for paired and unpaired output. The unpaired output files contain reads where the mate was removed because the quality was low.
HEADCROP indicates the number of bases to remove from the beginning regardless of quality, here we are using 0. 
ILLUMINACLIP specifies a file of adapter sequences, and the number of mismatches allowed in an adapter match. 
LEADING and TRAILING specify the minimum quality for trimming the start and end of reads. 
SLIDINGWINDOW indicates the size of the sliding window and the minimum average quality for the bases in that window. 
MINLEN specifies the minimum length for a read to be kept.
(1>)indicate where to write success output,(2>) where to write error output.

###indexGenome.sh

Using BWA we index the Genome
When an aligner indexes a reference, it identifies potential alignment sites quickly, saving time during alignment. Indexing only needs to be done once for the reference.
GRCh38_reference.fa is and inut file of the reference genome and bwasw [-a matchScore] Align query sequences in the in.fq file. When mate.fq is present, perform paired-end alignment. The paired-end mode only works for reads Illumina short-insert libraries.

###alignReads.sh

Align query sequences of 70 bp to 1 mbp using the BWA-MEM algorithm. This algorithm, in brief, relies on seeding alignments with maximum exact matches (MEMs) and then extending seeds with the affine-gap Smith-Waterman algorithm (SW).
-R STR	Complete read group header line. ’\t’ can be used in STR and will be converted to a TAB in the output SAM. The read group ID will be attached to every read in the output.
-P	In the paired-end mode, perform SW to rescue missing hits only but do not try to find hits that fit a proper pair.

###sort.sh

Samtools can be used to do a variety of things with sam files including viewing, sorting, merging, and indexing. 
-m INT Create a CSI index.
-@ INT Number of input/output compression threads to use in addition to main thread
-o Create output files in .bam format

###indexReads.sh

A new index file is created when you run samtools index. This allows you to search for data in a sorted BAM file more quickly.
-b provide output file in .bam format

###runDeepVariant.sh

Script to produce VCF File using Deep Variant

set allows you to change the values of shell options and set the positional parameters, 
-euo Each variable or function that is created or modified is given the export attribute, The shell shall write a message to standard error when it tries to expand a variable that  is  not
       set and immediately exit and  Write the current settings of the options to standard output in an unspecified format.
If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully.

Then we provided the path for input directory and reference, bam files, and created output directory using mkdir -p, output VCF, GVCF, log output directory.

Depending on the security policy, sudo allows a user to execute a command as a superuser or another user

To update the package index run the command. This will pull the latest changes from the APT repositories.

We install the docker and update if needed and the cpied the sorted bam, bai aligned genome reference files to the Input directory.

docker image can be pulled using sudo docker pull command.

using sudo docker run we can specify input and output directories using -v and model, reference genome and reads are specified. 
