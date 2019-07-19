#!/usr/bin/perl

@unsorted = (["aaaa","longest"],["a","shortest"],["aa","middle"]);



@sorted = map  { $_->[0] }
          sort { $a->[1] <=> $b->[1] } # use numeric comparison
          map  { [$_, length($_->[0])] }    # calculate the length of the string
               @unsorted;

# A K A
#  @sorted = map  { $_->[0] } sort { $a->[1] <=> $b->[1] }  map  { [$_, length($_->[0])] }  @unsorted;

for (@unsorted) {
	print $_->[1], "\n";
}
for (@sorted) {
	print $_->[1], "\n";
}

Generation:

     # reading from file
    while ( <> ) {
    push @AoA, [ split ];
    }
    # calling a function
    for $i ( 1 .. 10 ) {
    $AoA[$i] = [ somefunc($i) ];
    }
    # using temp vars
    for $i ( 1 .. 10 ) {
    @tmp = somefunc($i);
    $AoA[$i] = [ @tmp ];
    }
    # add to an existing row
    push @{ $AoA[0] }, "wilma", "betty";

    http://perldoc.perl.org/perldsc.html




Hashes of arrays:
     %HoA = (
    flintstones => [ "fred", "barney" ],
    jetsons => [ "george", "jane", "elroy" ],
    simpsons => [ "homer", "marge", "bart" ],
    );

    # reading from file
    # flintstones: fred barney wilma dino
    while ( <> ) {
    next unless s/^(.*?):\s*//;
    $HoA{$1} = [ split ];
    }

Array of Hashes:
    # reading from file
    # format: LEAD=fred FRIEND=barney
    while ( <> ) {
    $rec = {};
    for $field ( split ) {
    ($key, $value) = split /=/, $field;
    $rec->{$key} = $value;
    }
    push @AoH, $rec;
    }
    # reading from file
    # format: LEAD=fred FRIEND=barney
    # no temp
    while ( <> ) {
    push @AoH, { split /[\s+=]/ };
    }


COMPLETE ROUTING TABLE EXAMPLE


#!/usr/bin/perl

# routing table example

@table = ( ["192.168.1.0", "192.168.1.1", "255.255.255.0"],
                ["192.168.128.0", "192.168.128.1", "255.255.128.0"],
                ["192.168.0.0", "192.168.0.1", "255.255.128.0"],
                ["32.0.0.0", "32.0.0.1", "255.0.0.0"],
                ["192.168.0.0", "192.168.0.1", "255.255.0.0"],
                ["0.0.0.0", "1.2.3.4", "0.0.0.0"] );

@table = map { $_->[0] }
        sort { $b->[1] <=> $a->[1] }
        map { [$_, &dqtodec($_ -> [2])] } @table;

print "Dest\t\tGW\t\tMask\n";
for (@table) { 
    print $_ -> [0],"\t\t",$_ -> [1], "\t\t",$_ -> [2], "\n";
}

while (<STDIN>) {
    print "Dest\t\tGW\t\tMask\n";
    for (@table) { 
       print $_ -> [0],"\t\t",$_ -> [1], "\t\t",$_ -> [2], "\n";
    }
    chomp;
    $addr = &dqtodec($_);
    for (@table) {
        printf("Dest %032b\n", &dqtodec($_->[0]));
        printf("NM   %032b\n", &dqtodec($_->[2]));
        $match1 =  &dqtodec($_->[0]) & &dqtodec($_->[2]) ;
        printf("AND  %032b\n", $match1);
        printf("Ent  %032b\n", $addr);
        $match2 =  $addr & &dqtodec($_->[2]) ;
        printf("AND  %032b  ", $match2);
        if ($match1 == $match2) { 
            print "- Match!\n\n";
            last;
        }
        print "\n\n";
    }
}

sub dqtodec { 
    my $dq = shift;
    @b = ($dq =~ /([0-9]+).([0-9]+).([0-9]+).([0-9]+)/);
    return $b[0] * 256*256*256 + $b[1] * 256*256 + $b[2] * 256 + $b[3];
}

