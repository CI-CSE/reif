class APPLICATION
create make
feature
    make
        local
            values: ARRAY [INTEGER]
            source: NUMBER_SOURCE
        do
            create source
            create values.make_filled (source.value, 1, 2)
            print (values [1] + values [2])
            print ("%N")
            retry_check
            print ("rescued%N")
        end

    retry_check
        local
            recovered: BOOLEAN
            exceptions: EXCEPTIONS
        do
            if not recovered then
                create exceptions
                exceptions.raise ("wasm runtime smoke test")
            end
        rescue
            recovered := True
            retry
        end
end
