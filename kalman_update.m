function [new_state, new_covar] = kalman_update(measurement, state, pred_covar, ...
    meas_var)

    %what would measurement be given the state?
    if state ~= 0
        meas_model = (abs(state)+10)/state;
    else
        meas_model = 99999999;
    end
    
    %difference between the measurement derived from the state
    %and real measurement
    innov = measurement - state*meas_model;
    
    %finding out the innovation covariance
    innov_cov = meas_model*pred_covar*meas_model' + meas_var;
    
    %finding the kalman gain
    k_gain = pred_covar*meas_model'*inv(innov_cov);
    
    %finding the updated state
    new_state = state+k_gain*innov;
    new_covar = (1-k_gain*meas_model)*pred_covar;

end