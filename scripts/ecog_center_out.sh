#!/bin/bash
# Test cross-modal deep clustering on ECoG center-out dataset
# (modified from from https://github.com/yukimasano/self-label)
device="0"
DIR='/data2/users/kperks/ecog_center_out/ /data2/users/kperks/ecog_center_out/pose/'
subjects='BEIG0414c' # Beignet on 04-14-2022
run_num=13
savepath=./xdc_runs/center_out
param_lp=./models/center_out7  # model parameter file to use

# the network
ARCH='htnet htnet'
USE_ECOG='True True' # both True b/c pose srate = ECoG srate
HC=1
NCL=8 # number of expected clusters (K)
NFOLDS="10" # number of folds (can also be "loocv")

TMIN=-.5
TMAX=.5

# the training
WORKERS=1 # number of workers
BS=36 # batch size
AUG=0


# #########CROSS-MODAL MODEL#########

# IS_SUP="False" # is supervised
# IS_XDC="True" # is cross-modal
# NEP=200 # number of epochs                         -- was 200 for run 1-3, 200 for run 7
# nopts=50 # number of times to update pseudo-labels -- was  50 for run 1-3,  50 for run 7

# for SBJ in $subjects
# do
#     python main_n_multimodel_cv.py \
#             --device ${device} \
#             --imagenet-path ${DIR} \
#             --batch-size ${BS} \
#             --augs ${AUG} \
#             --epochs ${NEP} \
#             --nopts ${nopts} \
#             --hc ${HC} \
#             --arch ${ARCH} \
#             --ncl ${NCL} \
#             --workers ${WORKERS} \
#             --pat_id ${SBJ} \
#             --use_ecog ${USE_ECOG} \
#             --n_folds ${NFOLDS} \
#             --is_supervised ${IS_SUP} \
#             --is_xdc ${IS_XDC} \
#             --savepath ${savepath}_xdc_run${run_num}/ \
#             --param_lp ${param_lp} \
#             --t_min ${TMIN} \
#             --t_max ${TMAX};
# done

#########SUPERVISED MODEL#########

IS_SUP="True" # is supervised
IS_XDC="False" # is cross-modal
NEP=60 # number of epochs                           -- was 40 for run 1-3, 60 for run 4, 100 for run 5, 60 for run 6-13
nopts=40 # number of times to update pseudo-labels  -- was 20 for run 1-3, 40 for run 4,  50 for run 5, 40 for run 6-13

for SBJ in $subjects
do
    python main_n_multimodel_cv.py \
            --device ${device} \
            --imagenet-path ${DIR} \
            --batch-size ${BS} \
            --augs ${AUG} \
            --epochs ${NEP} \
            --nopts ${nopts} \
            --hc ${HC} \
            --arch ${ARCH} \
            --ncl ${NCL} \
            --workers ${WORKERS} \
            --pat_id ${SBJ} \
            --use_ecog ${USE_ECOG} \
            --n_folds ${NFOLDS} \
            --is_supervised ${IS_SUP} \
            --is_xdc ${IS_XDC} \
            --savepath ${savepath}_sup_run${run_num}/ \
            --param_lp ${param_lp} \
            --t_min ${TMIN} \
            --t_max ${TMAX};
done


# #########UNIMODAL MODEL#########

# IS_SUP="False" # is supervised
# IS_XDC="False" # is cross-modal
# NEP=60 # number of epochs                           -- was originally 40, 60 for run 7
# nopts=40 # number of times to update pseudo-labels  -- was originally 20, 40 for run 7

# for SBJ in $subjects
# do
#     python3 main_n_multimodel_cv.py \
#             --device ${device} \
#             --imagenet-path ${DIR} \
#             --batch-size ${BS} \
#             --augs ${AUG} \
#             --epochs ${NEP} \
#             --nopts ${nopts} \
#             --hc ${HC} \
#             --arch ${ARCH} \
#             --ncl ${NCL} \
#             --workers ${WORKERS} \
#             --pat_id ${SBJ} \
#             --use_ecog ${USE_ECOG} \
#             --n_folds ${NFOLDS} \
#             --is_supervised ${IS_SUP} \
#             --is_xdc ${IS_XDC} \
#             --savepath ${savepath}_sep_run${run_num}/ \
#             --param_lp ${param_lp} \
#             --t_min ${TMIN} \
#             --t_max ${TMAX};
# done