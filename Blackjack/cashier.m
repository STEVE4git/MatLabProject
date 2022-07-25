function [] = cashier(user,chip_val)
% cashier initiates a uifigure (fig2) prompting Doge Blackjack players to
% purchase chips.
%   Input arguements
%       user
%       chip_val
%   Output arguements
%       None
fig2 = uifigure('Name', 'Doge Blackjack - Cashier',                     ...
                    'Position', [215 56 1080 720],                      ...
                    'Color', 'black', 'Pointer','hand', 'Visible', 'off');

cashier_fig = uiimage(fig2, 'Position', [175 45 750 701] );                 
       cashier_fig.ImageSource = 'backgrounds\Cashier.jpg';

balance_label = uilabel(fig2, 'Position', [65 625 65 22],               ...
                             'HorizontalAlignment', 'right',            ...
                             'FontSize', 16,                            ...
                             'FontColor', [.15 .7 0], 'Text', 'Cash   $');

balance = uieditfield(fig2, 'numeric', 'Limits', [0 Inf],               ...
                           'Editable', 'off',                           ...
                           'ValueDisplayFormat', '%9.0f',               ...
                           'FontSize', 16,                              ...
                           'FontColor', [.15 .7 0],                     ...
                           'HorizontalAlignment', 'center',             ...
                           'BackgroundColor', [0.1 0.1 0.1],            ...
                           'Position', [135 625 70 22], 'Value', user.money);

buy_chips_spnr_lbl = uilabel(fig2, 'BackgroundColor', '#e6e6e6',        ...
                                 'Position', [430 250 315 22],          ...
                                 'FontSize', 14, 'FontWeight', 'Bold',  ...
                                 'HorizontalAlignment', 'Center');
       buy_chips_spnr_lbl.Text = 'Welcome! How many chips would you like?';


buy_chips_spnr = uispinner(fig2, 'Position', [510 218 65 22],           ...
          'Limits', [0 (user.money/chip_val)], 'ValueChangedFcn', @(buy_chips_spnr,event)...
            balance_changing(balance,buy_chips_spnr));

    function balance_changing(balance,buy_chips_spnr)
        balance.Value = user.money - buy_chips_spnr.Value * chip_val;
        user.chips = buy_chips_spnr.Value;
        user.money = balance.Value;
    end

buy_max = uibutton(fig2, 'push',                                        ...
                          'BackgroundColor', [0.85 0.85 0.85],          ...
                          'Position', [595 217 50 25],                  ...
                          'FontSize', 14, 'FontWeight', 'bold',         ...
                          'VerticalAlignment', 'Center',                ...
                     'FontColor', 'White', 'BackgroundColor', '#73d12e',...
                    'Text', 'max', 'ButtonPushedfcn', @(buy_max, event) ...
                      max_chip(buy_max, buy_chips_spnr));

    function max_chip(buy_max, buy_chips_spnr)
        total_amount = user.money/chip_val;
        max_chips_val = floor(total_amount);
        buy_chips_spnr.Value = max_chips_val;
        balance.Value = user.money - max_chips_val*total_amount; 
        user.money = user.money - max_chips_val*total_amount;
        user.chips = max_chips_val;
    end

play_btn = uibutton(fig2, 'push',                                       ...
                          'BackgroundColor', [0.85 0.85 0.85],          ...
                          'Position', [495 180 100 25],                 ...
                          'FontSize', 14, 'FontWeight', 'bold',         ...
                          'FontColor', 'Black',                         ...
                          'VerticalAlignment', 'Center',                ...
                          'Text', 'Let''s Play!',                       ...
                          'ButtonPushedFcn', @(play_btn, event)         ...
                          update_Val(play_btn, buy_chips_spnr));

    function [] = update_Val(play_btn, buy_chips_spnr)
        if user.chips > 0
            close(fig2);
            table(user, chip_val);
        else
            selection = uiconfirm(fig2,'You have no chips! Hit ok to buy chips or hit cancel to end the game!',...
            'No Chips!');
        switch selection
            case 'OK'
                cashier(user,chip_val);
            case 'Cancel'
                exit;
        end
    end  

fig2.Visible = 'on';

end