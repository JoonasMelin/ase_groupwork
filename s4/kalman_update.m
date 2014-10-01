function [new_state, new_covar] = kalman_update(measurement, state, pred_covar, ...
    meas_var)

    %what would measurement be given the state?
    meas_model = [1 0
                  0 1];

    
    %difference between the measurement derived from the state
    %and real measurement
    innov = measurement - meas_model*state;
    
    %finding out the innovation covariance
    innov_cov = meas_model*pred_covar*meas_model' + meas_var;
    
    %finding the kalman gain
    k_gain = pred_covar*meas_model'*inv(innov_cov);
    
    %finding the updated state
    new_state = state+k_gain*innov;
    new_covar = (1-k_gain*meas_model)*pred_covar;

end