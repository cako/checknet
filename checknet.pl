#!/usr/bin/perl 

#===============================================================================
#
#         FILE:  checknet.pl
#
#        USAGE:  ./checknet.pl
#                perl checknet.pl
#
#  DESCRIPTION:  First I checked if the internet was up by launching a browser
#                and going to www.google.com.
#                The I decided to start pinging it. Finally, I added an endless
#                loop and stuck in 'espeak' so I didnt have to sit at the
#                computer all day. This was in bash. I finally decided to port
#                it to perl, in order to clean it up a bit. This is the outcome.
#                The program will ping google. If it get's a solid connection
#                (all packets received), then it will say "Internet!" and try
#                again. It will remain quiet until the solid connection is lost.
#                To quit, use your shell's terminate sequence. In bash it's
#                CTRL-C.
#
#      OPTIONS:  Pass it options just like you would pass ping. In fact, if you
#                bring it up as ./checknet -h, it will output ping's help and
#                possible do weird stuff. Maybe when I learn command line
#                switches I'll fix that.
#
# REQUIREMENTS:  perl, ping, UNIX prompt, espeak
#         BUGS:  Probably many
#        NOTES:  ---          
#       AUTHOR:  Carlos Alberto da Costa Filho, c.dacostaf (gmail)
#      VERSION:  0.11
#      CREATED:  Sun Feb 27 20:31:05 BRT 2011
#     REVISION:  ---
#=============================================================================== 


my $args;
if (@ARGV) {
    $args = join ' ', @ARGV;                                # If there are arguments, join them to throw them over to ping.
} else {
    $args = "-c 3 www.google.com";                          # If there aren't any, just ping google thrice.
}

$speak = 1;                                                 # Keeps track of whether it should or not speak.  

while () {
    my $_ = `ping $args 2>&1`;                              # Give $args to ping. 2>&1 includes errors as part of stout. This is needed to capture "unknown host". 
    if ( /unknown host/){
        print "Not working yet, check again later.\n";
        $speak = 1;                                         # Ok, it's not working now. Next time, if it works, speak [l53].
    } elsif ( /(\d) packets transmitted, \1 received/ ){    # All packets received.
        print "It's working: no packets lost.\n";
        `espeak 'Inner net is up' 2> /dev/null` if $speak;  # Bring up espeak (with minnor corrections to speech!)
#       `date >> checknet.log`;                             # Keep log of times the internet was up.
         $speak = 0;                                        # If we just spoke, why speak again?
    } elsif ( /(\d) packets transmitted, 0 received/ ){
        print "Can connect, but losing all packets.\n";
        $speak = 1;
    } else {
        $speak = 0;
    }
}
