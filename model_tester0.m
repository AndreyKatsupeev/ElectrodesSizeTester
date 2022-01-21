clear -v

extra={'ball','solid ball = cylinder(0.2,0.2,0;0.2,0.2,1;0.2) and orthobrick(-1,-1,1;1,1,2) -maxh=0.05;'}
try fmdl=ng_mk_cyl_models(5,[8,0.5,1,1.5,2,2.5,3,3.5,4,4.5],[0.1],extra);
   catch 
    run ('')#path to eidors startup.m
  end_try_catch
fmdl0=ng_mk_cyl_models(5,[8,0.5,1,1.5,2,2.5,3,3.5,4,4.5],[0.1]);  
img= mk_image(fmdl,1); img.elem_data(fmdl.mat_idx{2}) = 2;
img0= mk_image(fmdl0,1);
fmdl.fwd_model.stimulation = mk_stim_patterns(8,9,[0,4],[0,1],{},1);
img.fwd_model.stimulation = mk_stim_patterns(8,9,[0,4],[0,1],{},1);
img0.fwd_model.stimulation = mk_stim_patterns(8,9,[0,4],[0,1],{},1);
v1=fwd_solve(img);
v0=fwd_solve(img0)
show_fem(img);
imdl = fmdl;
imdl.fwd_model = fmdl;
imgr = inv_solve(fmdl,v0,v1)
show_fem(imgr)