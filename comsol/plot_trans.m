% semilogy(freq, meandisp);

xlim([5000, 30000]);
ylim([0.1, 1.2]);
legend('d = 12', 'Interpreter', 'latex', 'FontSize', 10, 'location', 'southwest');

set(gca, 'TickLabelInterpreter', 'latex', 'Fontsize', 10);
grid on

xlabel('Frequenz [mHz]', 'Interpreter', 'latex', 'FontSize', 10)
ylabel('Transmission [m]', 'Interpreter', 'latex', 'FontSize', 10)
% title('d = 30 m ', 'Interpreter', 'latex', 'FontSize', 12)

box off

set(gcf, 'Units', 'centimeters', 'InnerPosition', [53, 5, 9, 8]);
set(gcf, 'Color', 'white');

savefig('dd05d');
saveas(gcf, 'dd05d', 'epsc');