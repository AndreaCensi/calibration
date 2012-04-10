function res = create_pictures(tuple_dir)

clear functions
addpath(tuple_dir)
tuple_files = dir(sprintf('%s/*.tuple', tuple_dir));

res = {};

for i=1:numel(tuple_files)
	[pathstr, basename, ext, versn] = fileparts(tuple_files(i).name);

	results_file = sprintf('%s_results', basename);
	l = eval(results_file); l = l{1}; 
	l.basename = basename;
	res{end+1} = l;
end



% compute Jij as params 7-10

for i=1:numel(res)
	% Original: res{i}.x = [res{i}.l_diam res{i}.r_diam res{i}.axle res{i}.l_x res{i}.l_y res{i}.l_theta];
	res{i}.x = [res{i}.l_diam/2 res{i}.r_diam/2 res{i}.axle res{i}.l_x res{i}.l_y res{i}.l_theta];

	% J11 = r_l /2
	% Original: res{i}.x(7) = res{i}.x(1) / 4;
	res{i}.x(7) = res{i}.x(1) / 2;

	df_dx = [1/4 0 0 0	0 0 ];
	res{i}.covariance(1:6,7) =	res{i}.covariance(1:6,1:6) *  df_dx';
	res{i}.covariance(7,1:6) =	res{i}.covariance(1:6,7)';
	res{i}.covariance(7,7) = df_dx * res{i}.covariance(1:6,1:6) * df_dx';
	
	% J12
	% Original: res{i}.x(8) = res{i}.x(2) / 4;
	res{i}.x(8) = res{i}.x(2) / 2;

	df_dx = [0 1/4 0 0 0  0 0];
	res{i}.covariance(1:7,8) =	res{i}.covariance(1:7,1:7) *  df_dx';
	res{i}.covariance(8,1:7) =	res{i}.covariance(1:7,8)';
	res{i}.covariance(8,8) = df_dx * res{i}.covariance(1:7,1:7) * df_dx';


	% J21
	a = res{i}.x(1);
	b = res{i}.x(3);
	f = - 0.5*a / b;
	df_da = - 0.5/b;
	df_db = + 0.5*a/b^2;
	df_dx = [df_da 0 df_db 0 0 0 0 0];

	res{i}.x(9) = f;
	res{i}.covariance(1:8,9) =	res{i}.covariance(1:8,1:8) *  df_dx';
	res{i}.covariance(9,1:8) =	res{i}.covariance(1:8,9)';
	res{i}.covariance(9,9) = df_dx * res{i}.covariance(1:8,1:8) * df_dx';

	% J22
	a = res{i}.x(2);
	b = res{i}.x(3);
	f = 0.5 * a / b;
	df_da = 0.5 /b;
	df_db = -0.5*a/b^2;
	df_dx = [df_da df_db];
	covx = res{i}.covariance([2 3],[2 3]);
	covf = df_dx * covx * df_dx';

	res{i}.x(10) = f;
	
	df_dx = [0 df_da df_db 0 0 0 0 0 0];

	res{i}.x(10) = f;
	res{i}.covariance(1:9,10) =	 res{i}.covariance(1:9,1:9) *  df_dx';
	res{i}.covariance(10,1:9) =	 res{i}.covariance(1:9,10)';
	res{i}.covariance(10,10) = df_dx * res{i}.covariance(1:9,1:9) * df_dx';
	

	[s,R] = cov2corr(res{i}.covariance);
	res{i}.corr = R;
end





figure;

nr=3;nc=4;

titles = { 'r_L','r_R','b','l_x','l_y','l_\theta','J11','J12','J21','J22'};
simpletitlestex = { 'r_L','r_R','b','l_x','l_y','l_\theta','J_{11}','J_{12}','J_{21}','J_{22}'};
titlestex = { 'r_{\mathrm{L}}','r_{\mathrm{R}}','b','\ell_x','\ell_y','\ell_\theta','J_{11}','J_{12}','J_{21}','J_{22}'};

titlestexstr = {}; for i=1:numel(titlestex); titlestexstr{i} = sprintf('$\\rule{0pt}{4mm}%s\\rule{2mm}{0pt}$', titlestex{i}); end

scales = { 1000, 1000, 1000, 1000, 1000, 180/pi, 1000, 1000, 180/pi, 180/pi};
units = { 'mm','mm','mm','mm','mm', 'deg','mm/s','mm/s','deg/s','deg/s'};

names={};
for i=1:numel(res)
names{i} = res{i}.basename;
end

for v=1:10
	subplot(nr,nc,v)
	hold on

	for i=1:numel(res)
		val = res{i}.x(v) ;

		% if (i == 1) | (i==2) 
		% 	% quick fix for radius/diameter problem
		% 	val = val / 2;
		% end

		sigma = sqrt( res{i}.covariance(v,v) );
		errorbar(i, scales{v}*val, scales{v}* 3*sigma);
	end
	ylabel(units{v})
	set(gca,'XTick',1:numel(res))
	set(gca,'XTickLabel',names);

	title(titles{v})
end



names={};
for i=1:numel(res)
	names{i} = res{i}.basename;
end
names

bigx=6.5; bigy=2.5;
% smallx=4.5; smally=2.5;
% all same size
smallx=6.5; smally=2.5;
sizex = {bigx,bigx,bigx,bigx,bigx,bigx,smallx,smallx,smallx,smallx};
sizey = {bigy,bigy,bigy,bigy,bigy,bigy,smally,smally,smally,smally};

names = {'A','A1','A2','A3','B','B1','B2','B3','C','C1','C2','C3'}
namestex = {'A','A_1','A_2','A_3','B','B_1','B_2','B_3','C','C_1','C_2','C_3'};
for i=1:numel(namestex); namestex{i} = sprintf('$\\rule{0pt}{3mm}%s$', namestex{i}); end
%for i=1:numel(namestex); namestex{i} = sprintf('$%s$', namestex{i}); end

tables_vars = { 1:6, 7:10, 1:10 };

for t=1:numel(tables_vars)
	f = fopen(sprintf('%s/bigtable%d.tex',tuple_dir, t), 'w');
	fprintf(f, '\\begin{tabular}{|r|c|c|c|c|c|c|c|c|c|c|}\n')
	fprintf(f, '\\hline\n')
	fprintf(f, ' ')
	
	tvars = tables_vars{t};
	
	for tv=1:numel(tvars)
		v = tables_vars{t}(tv);
		fprintf(f, '& %s (%s)', titlestexstr{v}, units{v});
	end
	fprintf(f, '\\\\ \n')
	fprintf(f, '\\hline\n')

	for i=1:numel(res)
	
		if mod(i,4) == 1
			fprintf(f, '\\hline\n')
		end
	
		fprintf(f, '%s & ', namestex{i});	

		for tv=1:numel(tvars)
			v = tvars(tv);
			val = scales{v}* res{i}.x(v) ;
			sigma = scales{v}* sqrt( res{i}.covariance(v,v) );
			fprintf(f, '$%.2f \\pm %.2f$', val, sigma );
					if tv<numel(tvars)
				fprintf(f, ' & ');
			end
		end
		fprintf(f, '\\\\ \n')
		fprintf(f, '\\hline\n')
	end

	fprintf(f, '\\end{tabular}\n')
end

% \multicolumn{2}{|c|}{Team sheet} \\

%return




for v=1:10
	f = my_figure(sizex{v},sizey{v});
	hold on

	data_x = [];
	data_y = [];
	data_e= [];
	for i=1:numel(res)
 		val =  res{i}.x(v) ;
		sigma = sqrt( res{i}.covariance(v,v) );
		data_x(i) = i;
		data_y(i) = scales{v} * val;
		data_e(i) = scales{v} * 3 * sigma;
	end
	h=errorbar(data_x, data_y, data_e, 'k');
	set(h, 'LineStyle', 'none');
	errorbar_tick(h,  0.4, 'units');

	a=axis;
	a(1:2) = [0, numel(res)+1];
	axis(a);
%
	my_fonts(ylabel(units{v}))
	set(gca,'XTick',(1:numel(res))+0.1)
%	set(gca,'XTickLabel',names);

	my_fonts(gca)
	format_ticks(gca, namestex, [], [],[],[],[],0, 0);


%	my_fonts(title(simpletitlestex{v}))
	
	print('-depsc2', sprintf('%s/var_%d.eps',tuple_dir,v))
	close(f)
end


for i=1:numel(res)
	f = my_figure(7,7);

	M = [res{i}.corr res{i}.corr(:,end); res{i}.corr(end,:) 0];
	pcolor(M);
	
	for a=1:10
	for b=1:10
		if a > b
			pc = floor(res{i}.corr(a,b) * 100);
			if abs(pc) == 100
				pc = 99 *sign(pc);
			end
			if pc > 0
				s = sprintf('+.%02d', abs(pc));
			else
				s = sprintf('-.%02d', abs(pc));
			end
			my_fonts(text(a+0.1,b+0.5,s));
		end
	end
	end
	
	set(gca,'XTick',(1:10) + 0.6)
	set(gca,'XTickLabel',titles);
	set(gca,'YTick',(1:10) + 0.6)
	set(gca,'YTickLabel',titles);
	
	format_ticks(gca, titlestexstr, titlestexstr, [],[],[],[], 0, 0);
	
	my_fonts(gca)
	
	print('-depsc', sprintf('%s/%s_correlation.eps',tuple_dir,res{i}.basename))
	
	close(f)
end


%%%%%%%% Only the numbers
for i=1:numel(res)
	f = my_figure(8,8);

%	M = [res{i}.corr res{i}.corr(:,end); res{i}.corr(end,:) 0];
	M = zeros(11,11);
	% all white
	colormap([1 1 1])
	pcolor(M);
	
	for a=1:10
	for b=1:10
		if a > b
			pc = floor(res{i}.corr(a,b) * 100);
			if abs(pc) == 100
				pc = 99 *sign(pc);
			end
			if pc > 0
				s = sprintf('+.%02d', abs(pc));
			else
				s = sprintf('-.%02d', abs(pc));
			end
			my_fonts(text(a+0.1,b+0.5,s));
		end
	end
	end
	
	set(gca,'XTick',(1:10) + 0.6)
	set(gca,'XTickLabel',titles);
	set(gca,'YTick',(1:10) + 0.6)
	set(gca,'YTickLabel',titles);
	
	format_ticks(gca, titlestexstr, titlestexstr, [],[],[],[], 0, 0);
	
	my_fonts(gca)
	
	print('-depsc', sprintf('%s/%s_correlation_bw.eps',tuple_dir,res{i}.basename))
	
	close(f)
end





fprintf('And now the long part (press enter)...\n')
pause


for i=1:numel(res)
	iterations = dir(sprintf('%s/%s_results_iter*.asc', tuple_dir, res{i}.basename));
	for a=1:numel(iterations)
		file = sprintf('%s/%s',tuple_dir,iterations(a).name);
		[pathstr, basename, ext] = fileparts(file);
		prefix = sprintf('%s/%s',tuple_dir, basename);

		create_pictures_iteration(file,prefix);
	end

end






