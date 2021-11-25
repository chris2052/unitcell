semilogy(d, min_disp_conc, d, min_disp_steel);

ylim([1e-8, 1]);
xlim([10, 50])
legend('Beton', 'Stahl', 'Interpreter', 'latex', 'FontSize', 10, 'location', 'southeast');

set(gca, 'TickLabelInterpreter', 'latex', 'Fontsize', 11);
grid on

xlabel('Durchmesser [m]', 'Interpreter', 'latex', 'FontSize', 11)
ylabel('min. Transmission [m]', 'Interpreter', 'latex', 'FontSize', 11)
% title('d = 30 m ', 'Interpreter', 'latex', 'FontSize', 12)

box off

set(gcf, 'Units', 'centimeters', 'InnerPosition', [53, 5, 12, 10]);
set(gcf, 'Color', 'white');

savefig('dd_min_trans_conc_steel');
saveas(gcf, 'dd_min_trans_conc_steel', 'epsc');