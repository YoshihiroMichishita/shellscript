#!/bin/bash

# enter your name on the cluster of condensed matter group
your_name=michishita


# N represent the parallel process you want to use
N=32
#振りたいパラメータをforループで回す。このループの中にsbatch job.shが含まれているので、自動的に複数のジョブを投げてくれる。
for eta in 0.01 0.02 
do

#表示されるjobの名前にパラメータの値が入る
job_name=Weyl_type1_eta${eta}

# you should make directory which holds the data, and the name should represent "when you calculate","what you calculate", and "what parameter you use".
dir=Weyl_type1_eta${eta}_0408

# The name of code which you want to run
file=tilted_Weyl_NLH.jl

# The name of directory you put the running code
file_dir=~/Codes/julia

# I recommend you to make directory named "Data", which hold all data folders.
mkdir -p /home/${your_name}/Data/${dir}/

# copy the runnig file to the data directory
cp ${file_dir}/${file} ~/Data/${dir}/

cd ~/Data/${dir}/

# make job.sh
cat >job.sh <<EOF
#!/bin/sh
#PBS -l nodes=1:ppn=${N}
#PBS -q workq
#PBS -m e
#PBS -M your_email_address
#PBS -N ${job_name}

orig_dir=/home/${your_name}/Data/${dir}
root_dir=/work/${your_name}/${dir} #work

mkdir -p \$root_dir

cp \${orig_dir}/${file} \${root_dir}/
cd \${root_dir}

#cd ~/Data/${dir}

#If you input the parameters
eta=${eta}
T=0.02
m=0.3
t=1.0
K_SIZE=50
W_SIZE=200
W_MAX=0.5

module load Julia/1.7.2
#if you use julia
julia ./${file} \${m} \${t} \${eta} \${T} \${K_SIZE} \${W_MAX} \${W_SIZE}

#Move the results(output files) to the Data directory
mv \${root_dir}/* \${orig_dir}
EOF

# you can choose the cluster p~~ instead of "p1792gb", such as "pcebu", "pepyc"
#sbatch -p p1792gb job.sh
# if you want to get e-mail after teh job finishes
qsub job.sh
echo "job is playing"

cd /home/michishita
done
