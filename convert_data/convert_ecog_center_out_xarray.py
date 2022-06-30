import os
import numpy as np
import xarray as xr

lp = '/data2/users/kperks/'
sp = 'ecog_center_out/'
# input_file = 'prep_data_lfp_mocap.npy'
# out_sbj_id = 'BEIG0414'
# input_file = 'prep_data_lfp_polar.npy'
# out_sbj_id = 'BEIG0414a'
# input_file = 'prep_data_lfp_posvel.npy'
# out_sbj_id = 'BEIG0414b'

# input_file = 'new_data_lfp_mocap.npy'
# out_sbj_id = 'BEIG0414c' # 3d position with outlier trials removed
# input_file = 'new_data_lfp_mocap.npy'
# out_sbj_id = 'BEIG0414d' # 2d position (xy) with outlier trials removed

# input_file = 'new_data_lfp_polar.npy'
# out_sbj_id = 'BEIG0414e'
# input_file = 'new_data_lfp_posvel.npy'
# out_sbj_id = 'BEIG0414f'

# input_file = 'new_data_lfp_mocap_rot.npy'
# out_sbj_id = 'BEIG0414g'
input_file = 'new_data_lfp_polar_rot.npy'
out_sbj_id = 'BEIG0414h'


if not os.path.exists(lp+sp):
    os.mkdir(lp+sp)
if not os.path.exists(lp+sp+'pose/'):
    os.mkdir(lp+sp+'pose/')

# Load data
data = np.load(lp+input_file, allow_pickle=True)
data = data.item()
ecog = data['lfp']
pose = data['mocap']
# pose = data['mocap'][:,1:,:] # 2d position (xy)
recording_day = data['events']
times = data['time']

# Randomize epoch order - INCLUDED FOR RUN 8 ONWARDS
order_inds = np.arange(ecog.shape[0])
np.random.shuffle(order_inds)
ecog = ecog[order_inds,...]
pose = pose[order_inds,...]
recording_day = (np.asarray(recording_day)[order_inds]).tolist()

# Check if labels are still the same between ECoG and pose data
assert (ecog[:, -1, 0].squeeze() == pose[:, -1, 0].squeeze()).all()

# Convert ECoG to xarray and save
da_ecog = xr.DataArray(ecog,
                    [('events', recording_day),
                    ('channels', np.arange(ecog.shape[1])),
                    ('time', times)])
da_ecog.to_netcdf(lp+sp+out_sbj_id+'_ecog_data.nc')

# Convert pose to xarray and save
da_pose = xr.DataArray(pose,
                    [('events', recording_day),
                    ('channels', np.arange(pose.shape[1])),
                    ('time', times)])
da_pose.to_netcdf(lp+sp+'pose/'+out_sbj_id+'_pose_data.nc')