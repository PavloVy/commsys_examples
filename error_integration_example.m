close all
clear all
field_elements = linspace(-5,5,300);

[xx,yy] = meshgrid(field_elements,field_elements);
size(xx)

snr = 10;

noise_power = 10.^(-snr/10);


qam_coords = [-1.5,-0.5,0.5,1.5];
[code_x, code_y] =meshgrid(qam_coords.',qam_coords);
code_x = reshape(code_x,16,1);
code_y = reshape(code_y,16,1);

%psk_angles = ((1:8)*45)/180*pi
%code_x = cos(psk_angles);
%code_y = sin(psk_angles);

results = zeros(1,length(code_x));
for our_code = 1%:length(code_x)
%our_code = 1;

x = code_x(our_code);
y = code_y(our_code);

pd =exp(-((xx-x).^2+(yy-y).^2)./(noise_power));
imagesc(field_elements,field_elements,pd)

our_sq_distance = (xx-x).^2+(yy-y).^2;

closeness_mask = ones(size(xx));

points_map = zeros(size(xx));
points_map = (our_sq_distance<0.11)*2;
wierd_mask = closeness_mask;
for i = 1:length(code_x)
  if (i!=our_code)

    x = code_x(i);
    y = code_y(i);
    another_sq_distance = (xx-x).^2+(yy-y).^2;
    mask_updater = another_sq_distance>our_sq_distance;
    closeness_mask = closeness_mask.*mask_updater;
    wierd_mask = wierd_mask + mask_updater;
    points_map = points_map+(another_sq_distance<0.1);
  endif


endfor
figure()
imagesc(wierd_mask)

%figure()
%imagesc(field_elements,field_elements,closeness_mask)
%figure()
%imagesc(field_elements,field_elements,(1-closeness_mask).*pd)
total = sum(sum(pd));
p_corr = sum(sum(closeness_mask.*pd))/total;
p_err = 1-p_corr;
results(our_code)=p_err;
endfor
plot(results)
