PROGRAM StoryGenerator;
    TYPE
        repWord = RECORD
            search, replace: STRING;
        END;
        List = ARRAY[1..100] OF repWord;


    PROCEDURE LineToWords(s: STRING; VAR search, replace: STRING);
        VAR
            n: INTEGER;
        BEGIN
            n := Pos(' ', s);
            search := Copy(s, 1, n-1);
            replace := Copy(s, n+1, Length(s) - n+1);
        END;


    FUNCTION FoundLetter(c: CHAR): BOOLEAN;
        VAR
            p: INTEGER;
        BEGIN
            p := Ord(c);
            IF (p >= 65) AND (p <= 90) THEN (* A-Z *)
            FoundLetter := TRUE
            ELSE IF (p >= 97) AND (p <=122) THEN (* a-z *)
            FoundLetter := TRUE
            ELSE IF (p = 129) OR (p = 132) OR (p = 142) OR (p = 225)
                OR (p = 148) OR (p = 153) OR (p = 154) THEN (* Ä, ä, Ö, ö, Ü, ü, ß *)   
            FoundLetter := TRUE
            ELSE
            FoundLetter := FALSE;
        END;




VAR
    i, n: INTEGER;
    s: STRING;
    c: CHAR;
    inputFile, replaceFile, outputFile: TEXT;
    replacements: List;


BEGIN

    i := Low(replacements);

    WriteLn('ParamCount: ', ParamCount);
    IF ParamCount <> 3 THEN BEGIN
        WriteLn(stderr, 'Usage: ', '<replaceFileName> <inputFileName> <outputFileName>');
        HALT;
    END;

    Assign(replaceFile, ParamStr(1));
    Assign(inputFile, ParamStr(2));
    Assign(outputFile, ParamStr(3));

    {$I-}
    Reset(replaceFile);
    Reset(inputFile);
    Rewrite(outputFile);
    {$I+}

    WHILE (i <= High(replacements)) AND (NOT EOF(replaceFile)) DO BEGIN
        ReadLn(replaceFile, s);
        LineToWords(s, replacements[i].search, replacements[i].replace);
        Inc(i);
    END;

    n := i - 1;
    s := '';

    WHILE NOT EOF(inputFile) DO BEGIN
        Read(inputFile, c);
        IF FoundLetter(c) = TRUE THEN
            s := s + c
        ELSE BEGIN
            IF s <> '' THEN BEGIN
                FOR i := Low(replacements) TO n DO
                    IF replacements[i].search = s THEN BEGIN
                        s := replacements[i].replace;
                        BREAK;
                    END;
                Write(outputFile, s);
                s := '';
            END;
            Write(outputFile, c); 
        END;
    END;
END.
