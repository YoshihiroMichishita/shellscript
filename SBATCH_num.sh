#!/bin/bash

# enter your name on the cluster of condensed matter group
your_name=michishita

job_name=test

# N represent the parallel process you want to use
N=20

# you should make directory which holds the data, and the name should represent "when you calculate","what you calculate", and "what parameter you use".
dir=TMD_11_02_NH_K900

# The name of code which you want to run
file=TMD_NH.out

# The name of directory you put the running code
file_dir=julia

# I recommend you to make directory named "Data", which hold all data folders.
mkdir -p /home/${your_name}/Data/${dir}/

# copy the runnig file to the data directory
cp ./${file_dir}/${file} ./Data/${dir}/

cd ./Data/${dir}/

# make job.sh
cat >job.sh <<EOF
#!/bin/sh
#SBATCH --ntasks=${N}
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=${N}
#SBATCH --ntasks-per-socket=${N}
#PBS -N ${job_name}

orig_dir=/home/michishita/Data/${dir}
root_dir=/work/michishita/${dir} #work

mkdir -p \$root_dir

cp \${orig_dir}/${file} \${root_dir}/
cd \${root_dir}

#If you input the parameters
W_SIZE=24000
W_MAX=2.4

#If you use c++
set OMP_NUM_THREADS=${N}
./${file} \$W_SIZE \$W_MAX

#if you use julia
julia ${file}

#Move the results(output files) to the Data directory
mv \${root_dir}/* \${orig_dir}
EOF

# you can choose the cluster p~~ instead of "p1792gb", such as "pcebu", "pepyc"
#sbatch -p p1792gb job.sh
# if you want to get e-mail after teh job finishes
sbatch -p ptuba -w tuba9 --mail-type=END --mail-user=yoshihiro.michishita@riken.jp job.sh
echo "job is playing"

cd ./../..
