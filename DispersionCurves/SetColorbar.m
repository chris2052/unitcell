function SetColorbar
cbar = colorbar('Location','east','AxisLocation','out');
% Dimensions of the colorbar     
cpos = get(cbar,'position'); 
% cpos(3) = cpos(3)/4 ;   % Reduce the width of colorbar by half
% cpos(2) = cpos(2)+.1 ;
% cpos(4) = cpos(4)-.2 ;
% cpos(1) = cpos(1)*0.9 ;
% set(cbar,'Position',cpos) ;
% brighten(0.5); 
     
% Title of the colorbar
set(get(cbar,'title'),'string','$|\textbf{u}|$ [m]','interpreter','latex');
%locate = get(cbar,'title');
%tpos = get(locate,'position');
%tpos(3) = tpos(3)+5. ;
%set(locate,'pos',tpos);
% Setting the values on colorbar
%
% get the color limits
clim = caxis;
ylim(cbar,[clim(1) clim(2)]);
numpts = 3 ;    % Number of points to be displayed on colorbar
kssv = linspace(clim(1),clim(2),numpts);
set(cbar,'YtickMode','manual','YTick',kssv); % Set the tickmode to manual
for i = 1:numpts
    imep = num2str(kssv(i),'%+3.2E');
    vasu(i) = {imep} ;
end
set(cbar,'YTickLabel',vasu(1:numpts),'fontsize',20);