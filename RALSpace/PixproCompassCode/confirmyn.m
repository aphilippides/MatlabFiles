function yn=confirmyn(str)
    inp = [];
    while ~strcmpi(inp,'y') && ~strcmpi(inp,'n')
        inp = input(str,'s');
    end
    yn = strcmpi(inp,'y');
end