% Basic 3d model $Id: basic_3d_01.m 2161 2010-04-04 20:33:46Z aadler $

fmdl= ng_mk_cyl_models(5.5,[6,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5],[0.05,0.05,0.25]); 
show_fem(fmdl);

imdl = mk_common_model('a2c2',8); % Will replace most fields
imdl.fwd_model = fmdl;
imdl.fwd_model.stimulation = mk_stim_patterns(60,1,[0,3],[0,1],{},1);
img1 = mk_image(imdl);

%show_fem(img1);

#print_convert('basic_3d_01a.png','-density 60')

% Basic 3d model $Id: basic_3d_02.m 3790 2013-04-04 15:41:27Z aadler $

% Add a circular object at 0.2, 0.5
% Calculate element membership in object
select_fcn = inline('(x-0.2).^2 + (y-0.5).^2 + (z-2).^2 < 0.3^2','x','y','z');
memb_frac = elem_select( img1.fwd_model, select_fcn);
img2 = mk_image(img1, 1 + memb_frac );

img2.calc_colours.cb_shrink_move = [0.3,0.6,0.02];
figure(2); show_fem(img2,1); axis tight;
%show_3d_slices(img2,[0.5,1,1.5,2,2.5,3,3.5,4,4.5,5])
%print_convert('basic_3d_02a.png','-density 60');

% Basic 3d model $Id: basic_3d_04.m 2161 2010-04-04 20:33:46Z aadler $

% Simulate Voltages and plot them
vh= fwd_solve(img1);
vi= fwd_solve(img2);

%plot([vh.meas, vi.meas]);
axis tight
%print_convert('basic_3d_04a.png','-density 60',0.4);
% Reconstruction Model $Id: basic_3d_05.m 3126 2012-06-08 16:17:56Z bgrychtol $
J = calc_jacobian( calc_jacobian_bkgnd( imdl) );
iRtR = inv(prior_noser( imdl ));
hp = 0.17;
iRN = hp^2 * speye(size(J,1));
RM = iRtR*J'/(J*iRtR*J' + iRN);
imdl.solve = @solve_use_matrix; 
imdl.solve_use_matrix.RM  = RM;
% Reconstruct Model $Id: basic_3d_06.m 2161 2010-04-04 20:33:46Z aadler $
imgr = inv_solve(imdl, vh, vi);

imgr.calc_colours.ref_level = 0; % difference imaging
imgr.calc_colours.greylev = -0.05;
figure(3);
%show_fem(imgr);
%show_slices(imgr,[2.5]*[1])
show_3d_slices(imgr,[0.5,1,1.5,2,2.5,3,3.5,4,4.5,5])
razn = struct;
size1 = size(img2.elem_data,1);
for i = 1:size1
  razn.elem_data(i)=img2.elem_data(i)-img1.elem_data(i);
  razn.elem_data(i)=abs(abs(razn.elem_data(i))-abs(imgr.elem_data(i)));
end
sum = 0;
for i = 1:size1
  sum=sum+razn.elem_data(i);
end
sum=sum/size1