function SetColorbar

    cbar = colorbar('eastoutside');

    % Title of the colorbar
    set(get(cbar,'title'),'string','$|\bm{u}|$ [m]','interpreter','none');

    % get the color limits
    clim = caxis;
    ylim(cbar,[clim(1) clim(2)]);
    numpts = 5 ;    % Number of points to be displayed on colorbar
    kssv = linspace(clim(1),clim(2),numpts);
    set(cbar,'YtickMode','manual','YTick',kssv); % Set the tickmode to manual
    for i = 1:numpts
        imep = num2str(kssv(i),'%+3.2E');
        vasu(i) = {imep} ;
    end
    set(cbar,'YTickLabel',vasu(1:numpts));

end