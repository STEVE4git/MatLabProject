function [user_return,fig1_return] = cashier(user,chip_val,fig1,pix_ss)
% cashier initiates a uifigure (fig1) prompting Doge Blackjack players to
% purchase chips.
%   Input arguments
%       user
%       chip_val
%   Output arguments
%       None

clf(fig1);
cashier_fig = uiimage(fig1, 'Position', pix_ss );                 
       cashier_fig.ImageSource = 'backgrounds\Cashier.jpg';

uilabel(fig1, 'Position', [65 625 65 22],               ...
                             'HorizontalAlignment', 'right',            ...
                             'FontSize', 16,                            ...
                             'FontColor', [.15 .7 0], 'Text', 'Cash   $');

balance = uieditfield(fig1, 'numeric',               ...
                           'Editable', 'off',                           ...
                           'ValueDisplayFormat', '%9.0f',               ...
                           'FontSize', 16,                              ...
                           'FontColor', [.15 .7 0],                     ...
                           'HorizontalAlignment', 'center',             ...
                           'BackgroundColor', [0.1 0.1 0.1],            ...
                           'Position', [135 625 70 22], 'Value', user.money);
 uilabel(fig1, 'Position', [5 500 120 22],               ...
                             'HorizontalAlignment', 'right',            ...
                             'FontSize', 16,                            ...
                             'FontColor', [.15 .7 0], 'Text', 'Current chips:');

chips_display = uieditfield(fig1, 'numeric',               ...
                           'Editable', 'off',                           ...
                           'ValueDisplayFormat', '%9.0f',               ...
                           'FontSize', 16,                              ...
                           'FontColor', [.15 .7 0],                     ...
                           'HorizontalAlignment', 'center',             ...
                           'BackgroundColor', [0.1 0.1 0.1],            ...
                           'Position', [135 500 70 22], 'Value', user.chips);                       

buy_chips_spnr_lbl = uilabel(fig1, 'BackgroundColor', '#e6e6e6',        ...
                                 'Position', [490 640 938 22],          ...
                                 'FontSize', 14, 'FontWeight', 'Bold',  ...
                                 'HorizontalAlignment', 'Center');
       buy_chips_spnr_lbl.Text = 'Welcome! How many chips would you like? Click the box and type the amount or click the arrows!';

buy_chips_spnr = uispinner(fig1, 'Position', [490 540 938 100],           ...
          'Limits', [0 user.money/chip_val], 'ValueChangedFcn', @(buy_chips_spnr,event)...
            balance_changing(balance,buy_chips_spnr));

    function balance_changing(balance,buy_chips_spnr)
        balance.Value = user.money - buy_chips_spnr.Value * chip_val;
        chips_display.Value = user.chips + buy_chips_spnr.Value;
    end

uibutton(fig1, 'push',                                        ...
                          'BackgroundColor', [0.85 0.85 0.85],          ...
                          'Position', [840 400 300 100],                  ...
                          'FontSize', 14, 'FontWeight', 'bold',         ...
                          'VerticalAlignment', 'Center',                ...
                     'FontColor', 'White', 'BackgroundColor', '#73d12e',...
                    'Text', 'Buy MAX chips', 'ButtonPushedfcn', @max_chip);

    function max_chip(~,~,~)
        total_amount = user.money/chip_val;
        max_chips_val = floor(total_amount);
        buy_chips_spnr.Value = max_chips_val;
        chips_display.Value = max_chips_val;
        
        balance.Value = user.money - max_chips_val*chip_val; 
    end

uibutton(fig1, 'push',                                       ...
                          'BackgroundColor', [0.85 0.85 0.85],          ...
                          'Position', [840 300 300 100],                 ...
                          'FontSize', 14, 'FontWeight', 'bold',         ...
                          'FontColor', 'Black',                         ...
                          'VerticalAlignment', 'Center',                ...
                          'Text', "Let's Play!",                       ...
                          'ButtonPushedFcn', @update_val);

    function [] = update_val(~,~)
        user.chips = user.chips + buy_chips_spnr.Value;
        user.money = user.money - chip_val*buy_chips_spnr.Value;
        if user.chips > 0
            clf(fig1);
            user_return = user;
            fig1_return = fig1; 
            uiresume(fig1);
           
        else
            selection = uiconfirm(fig1,'You have no chips! Hit ok to buy chips or hit cancel to end the game!',...
            'No Chips!');
            switch selection
                case 'OK'
                case 'Cancel'
                exit;
            end
        end
    end  
fig1.Visible = 'on';
uiwait(fig1);
end