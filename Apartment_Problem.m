clear all
close all
clc;

%load data
data = load('data.csv');
x1 = data(:,1);
x2 = data(:,2);
y = data(:,3);

f = fit([x1,x2],y,'poly11','Normalize','on');
figure;
plot( f, [x1, x2], y );
legend( 'fit 1', 'x1 vs x2, y', 'Location', 'NorthEast' );
title('Apartment Data Plot');
xlabel( 'x1 - Number of bedrooms in apartment' );
ylabel( 'x2 - Size of the apartment' );
zlabel( 'y - Rent of the apartment ' );
grid on
axis tight

% Normalize
x1_norm=(x1-mean(x1))./(max(x1)-min(x1));
x2_norm=(x2-mean(x2))./(max(x2)-min(x2));
y_norm=(y-mean(y))./(max(x2)-min(x2));

alpha = 0.001;
theta0 = 0;
theta1 = 0;
theta2 = 0;
j_min = [];
j_min_total = [];
j_theta_opt = [];
k=0;

x_i = [0; 0; 0;];
x_i1 = [0.01; 0.01; 0.01];

while norm(max(x_i1-x_i))>0.001
    x_i=x_i1;
    j_theta = 0;
    j_theta0 = 0;
    j_theta1 = 0;
    j_theta2 = 0;
    
    for i=1:30
    j_theta0=j_theta0+(x_i(1)+(x_i(2)*x1_norm(i))+(x_i(3)*x2_norm(i))-y_norm(i));
    j_theta1=j_theta1+((x_i(1)+(x_i(2)*x1_norm(i))+(x_i(3)*x2_norm(i))-y_norm(i))*x1_norm(i));
    j_theta2=j_theta2+(([x_i(1)+(x_i(2)*x1_norm(i))+(x_i(3)*x2_norm(i))-y_norm(i)])*x2_norm(i));
    end
    
   j_theta = [j_theta0; j_theta1; j_theta2];
   
   j_min = 0;
   
   x_i1 = x_i - alpha * [j_theta0;j_theta1;j_theta2];
  
   for i = 1:30
     j_min =  j_min+0.5*((x_i(1)+x_i1(2)*x1_norm(i)+x_i1(3)*x2_norm(i))-y_norm(i));
   end
   
   j_min_total=[j_min_total,j_min];
   k = k+1;
end

J_theta_opt = [j_theta_opt,j_theta]';
disp('optimal Vector:')
J_theta_opt

figure;
plot(1:length(j_min_total),j_min_total)
title('Linear Model');
    
MSE = (mean(mean((double(j_min_total) - double(j_min)).^2,2),1));
disp('Mean Square Error Value')
MSE


