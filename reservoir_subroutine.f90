SUBROUTINE reservoir_subroutine(T_epil_temp,T_hypo_temp, volume_e_x,volume_h_x,energy_x2)
   use Block_Reservoir

implicit none

real :: volume_e_x, volume_h_x, T_epil_temp, T_hypo_temp, energy_x2

  ! -------------------- calculate temperature terms  -------------------------
      dif_epi_x = v_t * area * (T_hypo_temp - T_epil_temp) * delta_t / (volume_e_x + volume_h_x)
      dif_hyp_x = v_t * area * (T_epil_temp - T_hypo_temp) * delta_t / (volume_e_x + volume_h_x)

  ! --------------------- calculate advection terms --------------------------- 
         advec_in_epix  = flow_in_epi_x * (stream_T_in - T_epil_temp) * delta_t / volume_e_x
         advec_epi_hyp = flow_epi_hyp_x *  (T_epil_temp - T_hypo_temp) * delta_t / volume_e_x
         advec_in_hypx = flow_in_hyp_x * (stream_T_in - T_hypo_temp) * delta_t / &
                         volume_h_x
         advec_in_hypx = advec_in_hypx + advec_epi_hyp
        ! advec_out_hypx = flow_out_hyp_x * T_hypo_temp

  ! ------------------------- calculate dV/dt terms ---------------------------
         dV_dt_epi = (flow_in_epi_x - flow_out_epi_x - flow_epi_hyp_x) * T_epil_temp
         dV_dt_hyp = (flow_in_hyp_x + flow_epi_hyp_x - flow_out_hyp_x) * T_hypo_temp

  ! ------------------- calculate change in temperature  ---------------------
      ! ---------------- epilimnion -----------
         ! ------------ calculate total energy ----------
          energy_x  = (q_surf * delta_t ) / (depth_e * density * heat_c_kcal ) ! kcal/sec*m2 to m3*C/sec
          temp_change_ep = advec_in_epix + energy_x  +  dif_epi_x ! - advec_out_epix  - dV_dt_epi
         ! temp_change_ep = temp_change_ep * delta_t / volume_e_x
         !----- update epilimnion volume for next time step -------
          volume_e_x = volume_e_x + (flow_in_epi_x - flow_out_epi_x - flow_epi_hyp_x ) * delta_t
          T_epil_temp = T_epil_temp +  temp_change_ep

      ! ------------------ hypolimnion ----------------
         ! ------------ calculate total energy ----------
          temp_change_hyp = advec_in_hypx + dif_hyp_x ! - advec_out_hypx - dV_dt_hyp
          temp_change_hyp = temp_change_hyp
         !----- update epilimnion volume for next time step -------
          volume_h_x = volume_h_x + (flow_in_hyp_x - flow_out_hyp_x + flow_epi_hyp_x) * delta_t
          T_hypo_temp = T_hypo_temp +  temp_change_hyp

  !---------- calculate combined (hypo. and epil.) temperature of outflow -----
    outflow_x = flow_out_epi_x + flow_out_hyp_x
    epix = T_hypo_temp*(flow_out_epi_x/outflow_x)  ! portion of temperature from epilim. 
    hypox= T_hypo_temp*(flow_out_hyp_x/outflow_x)  ! portion of temperature from hypol.
    temp_out_tot = epix + hypox

end subroutine reservoir_subroutine
