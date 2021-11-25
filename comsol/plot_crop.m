% semilogy(freq, meandisp);

xlim([5000, 30000]);
ylim([1e-11, 4])
legend('d = 18', 'Interpreter', 'latex', 'FontSize', 10, 'location', 'southeast');

set(gca, 'TickLabelInterpreter', 'latex', 'Fontsize', 10);
grid on

xlabel('Frequenz [mHz]', 'Interpreter', 'latex', 'FontSize', 12)
ylabel('Transmission [m]', 'Interpreter', 'latex', 'FontSize', 12)
% title('d = 30 m ', 'Interpreter', 'latex', 'FontSize', 12)

box off

set(gcf, 'Units', 'centimeters', 'InnerPosition', [53, 5, 9, 8]);
set(gcf, 'Color', 'white');

savefig('d05d_18_rot_steel');
saveas(gcf, 'd05d_18_rot_steel', 'epsc');