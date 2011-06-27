function create_pictures_iteration(iteration_file, prefix)


if exist(sprintf('%s_sm.eps', prefix))
    fprintf('Already did  %s -- remove files if you want to do it again\n', prefix)
    return
end

fprintf('Drawing %s\n', prefix);

fclose = @(f) close(f);
fsizex = 5;
fsizey = 3;


d = load(iteration_file)';

T = d(1,:);
phi_r = d(2,:);
phi_l = d(3,:);

sm = d(4:6,:);
o = d(7:9,:);

err = d(10:12,:);

est_sm = d(13:15,:);
err_sm = d(16:18,:);


time = [T(1)];
for i=2:numel(T)
	time(i) = time(i-1) + T(i);
end


f=my_figure(fsizex*2,fsizey);  nr=1;nc=2;
    subplot(nr,nc,1);
    h=plot(sm(1,:)*1000,sm(2,:)*1000,'.');
    set(h,'MarkerSize',1)
    my_fonts(xlabel('mm'))
    my_fonts(ylabel('mm'))
    axis('equal')
    my_fonts(title('scan matching x,y'));
    my_fonts(gca);
    
    subplot(nr,nc,2);
    hist(rad2deg(sm(3,:)),100);
    my_fonts(xlabel('deg'))
    my_fonts(title('scan matching theta'));
    my_fonts(gca);
    
print('-depsc2', sprintf('%s_sm.eps', prefix))
fclose(f)


f=my_figure(fsizex,fsizey);  
    plot(time, phi_l,'b-'); hold on;
    plot(time, phi_r,'r-')
    my_fonts(xlabel('time (s)'))
    my_fonts(ylabel('speed (rad/s)'))
    my_fonts(legend('\omega_l','\omega_r'))
    my_fonts(title('velocity profile'))
    my_fonts(gca);
print('-depsc2', sprintf('%s_vel.eps', prefix))
fclose(f)


f=my_figure(fsizex*2,fsizey);  nr=1;nc=2;
    subplot(nr,nc,1);
    h=plot(o(1,:)*1000,o(2,:)*1000,'.');
    set(h,'MarkerSize',1)
    my_fonts(xlabel('mm'))
    my_fonts(ylabel('mm'))
    axis('equal')
    my_fonts(title('motion x,y'));
    my_fonts(gca);
    
    subplot(nr,nc,2);
    hist(rad2deg(o(3,:)),100);
    my_fonts(xlabel('deg'))
    my_fonts(ylabel('samples'));
    my_fonts(title('motion theta'));
    my_fonts(gca);

print('-depsc2', sprintf('%s_motion.eps', prefix))
fclose(f)



f=my_figure(fsizex*4,fsizey);  nr=1;nc=4;

    subplot(nr,nc,1);
    h=plot(err(1,:)*1000,err(2,:)*1000,'.');
    set(h,'MarkerSize',1)
    my_fonts(xlabel('mm'))
    my_fonts(ylabel('mm'))
    axis('equal')
    my_fonts(title('error x,y'));
    my_fonts(gca);

    subplot(nr,nc,2);
    hist(err(1,:)*1000,100);
    my_fonts(xlabel('mm'))
    my_fonts(title('error x'));
    my_fonts(gca);
    
    subplot(nr,nc,3);
    hist(err(2,:)*1000,100);
    my_fonts(xlabel('mm'))
    my_fonts(title('error y'));
    my_fonts(gca);

    subplot(nr,nc,4);
    hist(rad2deg(err(3,:)),100);
    my_fonts(xlabel('deg'))
    my_fonts(title('error theta'));
    my_fonts(gca);

print('-depsc2', sprintf('%s_errors.eps', prefix))
fclose(f)



f=my_figure(fsizex*2,fsizey);  nr=1;nc=2;

    subplot(nr,nc,1);
    h=plot(est_sm(1,:)*1000,est_sm(2,:)*1000,'.');
    set(h,'MarkerSize',1)
    my_fonts(xlabel('mm'))
    my_fonts(ylabel('mm'))
    axis('equal')
    my_fonts(title('estimated sm x,y'));
    my_fonts(gca);

    subplot(nr,nc,2);
    hist(rad2deg(est_sm(3,:)),100);
    my_fonts(xlabel('deg'))
    my_fonts(title('estimated sm theta'));
    my_fonts(gca);

print('-depsc2', sprintf('%s_estsm.eps', prefix))
fclose(f)




f=my_figure(fsizex,fsizey);
    my_fonts(title('scan matching \theta vs estimated'))
    plot(rad2deg(est_sm(3,:)), rad2deg(sm(3,:)), 'r.')

    hold on;
    m = max(abs(rad2deg(est_sm(3,:))));
    plot([-m m],[-m m],'k--');
    axis('equal')
    my_fonts(xlabel('scan matching (deg)'))
    my_fonts(ylabel('estimated from odo + calib (deg)'))
    my_fonts(gca);
    
print('-depsc2', sprintf('%s_es.eps', prefix))
fclose(f)



