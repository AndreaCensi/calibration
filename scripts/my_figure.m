function f= my_figure(fsizex, fsizey)
f= figure;
set(f,'Units','centimeters');
set(f,'Position',[0 0 fsizex fsizey]);
set(f,'PaperUnits','centimeters');
set(f,'PaperPosition',[0 0 fsizex fsizey]);
set(f,'PaperSize',[fsizex fsizey])