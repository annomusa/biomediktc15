function [result, vote, classification] = doClassification(mySelectedPath, K)

    %clear all; close all;

    myClass = load('class.mat');

    % testing data
    %mySelectedPath = '.\smear dataset\carcinoma\149143370-149143378-001.BMP';
    %mySelectedPath = '.\smear dataset\moderate displastic\148848523-148848538-001.BMP';

    [valueTesting] = analysTesting(mySelectedPath);

    classification = [];

    theClass = myClass.class;
    len = length(theClass);
    for i = 1 : len
        c = {};
        curClass = theClass(i).value;
        lenInner = length(curClass);
        for j = 1 : lenInner
            c.class = theClass(i).class;
            % get distance
            [c.distance] = euclid(curClass(j), valueTesting);
            classification = [classification, c];
        end
    end

    % voting
    [vote] = voting(classification, K);
    result = vote(5).class;
    
end