function im=draw_string(word,varargin)
% Draw a string into an array
% IM=DRAW_STRING(WORD,...) accepts an ASCII string WORD (it does
% work with Unicode, but does not render cursive scripts correctly, such
% as Arabic) and it renders an image IM containing the string 
% typeset according to the default interpreter.
%   Options:
%       'FontSize' - the font size in default units (default: 64);
%       'Font'     - the name of the font to use (default: LucidaSansRegular);
%       'Method'   - the name of the function to draw string: either
%                    'text' or 'insertString' (default: 'text');
%
% NOTE: Use 'Method' value 'insertString' for Latin script texts (such as
% English), as it seems to always produce the correct results. The other
% method 'text' works with Arabic, but at the moment seems broken for Latin
% scripts.
%
    p=inputParser;
    p.addRequired('word');
    p.addParameter('Font','LucidaSansRegular');
    p.addParameter('FontSize',64,@isscalar);
    expectedMethods = {'text','insertString'};
    p.addParameter('Method','text',@(x) any(validatestring(x, expectedMethods)));
    p.parse(word,varargin{:});

    switch p.Results.Method,
      case 'text',
        im=draw_string_with_text(p.Results);
      case 'insertString'
        im=draw_string_with_insertString(p.Results);
    end
end

function im=draw_string_with_text(args)
% This uses 'text' function to draw the string and 'getframe' for rasterizing
    % This allocates array which should suffice to hold the string rendition
    word = args.word;
    Height=2*args.FontSize;
    Width=length(word)*5*args.FontSize;
    f=figure;
    %set(f,'Visible','off','DoubleBuffer','off','Position',[0,0,1920,1024]);
    set(f,'Visible','off','DoubleBuffer','off','Position',[0,0,Width,Height]);
    ax=axes(f,'Units','points');
    position=[0,0];
    % Modified Portion
    set(ax, 'xlim', [0,Width], 'ylim', [0,Height])
    RGB = text(ax, 0.5*Width, 0.5*Height, word,...
               'FontSize', args.FontSize,...
               'FontName',args.Font,...
               'HorizontalAlignment','center');
    % End Modified Portion
    set(ax, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
    F=getframe(ax);
    RGB=frame2im(F);
    % Crop the image
    BW=imbinarize(rgb2gray(RGB));
    %BW=BW(:,4:end); 
    A=sum(~BW,1);
    B=sum(~BW,2);
    [yl,yh]=bounds(find(B));
    [xl,xh]=bounds(find(A));
    delete(f);
    im=BW(yl:yh,xl:xh);
end


function im=draw_string_with_insertString(args)
% This uses 'insertText' function to draw the string directly
    ;
    % This allocates array which should suffice to hold the string rendition
    word = args.word;
    Height=2*args.FontSize;
    Width=length(word)*5*args.FontSize;
    I=zeros(Height,Width,3);

    position=[0,0];
    RGB = insertText(I, position, word, 'FontSize', args.FontSize,...
                     'Font',args.Font,...
                     'TextColor', 'white', 'BoxColor','black','BoxOpacity', 1);
    % Crop the image
    BW=imbinarize(rgb2gray(RGB));
    A=sum(BW,1);
    B=sum(BW,2);
    [yl,yh]=bounds(find(B));
    [xl,xh]=bounds(find(A));
    im=~BW(yl:yh,xl:xh);
end