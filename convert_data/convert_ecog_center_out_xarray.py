import os
import numpy as np
import xarray as xr

lp = '/data2/users/kperks/'
sp = 'ecog_center_out/'
input_file = 'prep_data_lfp_mocap.npy'
out_sbj_id = 'BEIG0414'

if not os.path.exists(lp+sp):
    os.mkdir(lp+sp)
if not os.path.exists(lp+sp+'pose/'):
    os.mkdir(lp+sp+'pose/')

# Load data
data = np.load(lp+input_file, allow_pickle=True)
data = data.item()
ecog = data['lfp']
pose = data['mocap']
recording_day = data['events']
times = data['time']

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