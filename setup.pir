#!/usr/bin/env parrot

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    .const 'Sub' libdetect = 'libdetect'
    register_step_before('build', libdetect)

    $P0 = new 'Hash'
    $P0['name'] = 'dbm-dynpmcs'
    $P0['abstract'] = 'dynpmc interface to dbm-like databases.'
    $P0['description'] = 'dynpmc to encapsulate and abstract the myriad of dbm-like databases under a sigle interface.'
    $P1 = split ' ', 'gdbm qdbm ndbm sdbm dbm bdb parrot dynpmcs'
    $P0['keywords'] = $P1
    $P0['license_type'] = 'Artistic License 2.0'
    $P0['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    $P0['copyright_holder'] = 'Parrot Foundation'
    $P0['authority'] = 'http://gitorious.org/dbm-dynpmcs'
    $P0['checkout_uri'] = 'git://gitorious.org/dbm-dynpmcs/dbm-dynpmcs.git'
    $P0['browser_uri'] = 'http://gitorious.org/dbm-dynpmcs'
    $P0['project_uri'] = 'http://gitorious.org/dbm-dynpmcs'

    # build
    $P2 = new 'Hash'
    $P2['gdbmhash'] = 'src/pmc/gdbmhash.pmc'
    $P0['dynpmc'] = $P2
    $S0 = get_ldflags()
    $P0['dynpmc_ldflags'] = $S0

    #test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0

    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'get_ldflags' :anon
    .local pmc config
    config = get_config()
    $S0 = '-lgdbm'
    $S1 = config['osname']
    unless $S1 == 'MSWin32' goto L1
    $S0 = '-llibgdbm'
    $S2 = config['cc']
    if $S2 == 'gcc' goto L1
    $S0 = 'gdbm.lib'
  L1:
    .return ($S0)
.end

.sub 'libdetect' :anon
    .param pmc kv :slurpy :named

    $S0 = get_ldflags()
    $S0 = cc_run(<<'SOURCE_C', $S0 :named('ldflags'), 0 :named('verbose'))
#include <stdio.h>
#include <stdlib.h>
#include <gdbm.h>

int
main(int argc, char *argv[])
{
    GDBM_FILE dbf;
    datum key, val_in, val_out;

    dbf = gdbm_open("gdbm_test_db", 0, GDBM_NEWDB, 0666, 0);
    if (!dbf) {
        fprintf(stderr, "File %s could not be created.\n", argv[1]);
        exit(2);
    }

    key.dptr  = "Is gdbm funktional?";
    key.dsize = 19;
    val_in.dptr  = "gdbm is working.";
    val_in.dsize = 17;

    gdbm_store(dbf, key, val_in, GDBM_INSERT);

    val_out = gdbm_fetch(dbf, key);

    if (val_out.dsize > 0) {
        printf("%s\n", val_out.dptr);
        free(val_out.dptr);
    }
    else {
        printf("Key not found.\n");
    }
    gdbm_close(dbf);

    return EXIT_SUCCESS;
}
SOURCE_C

    $I0 = index $S0, "gdbm is working."
    if $I0 == 0 goto L1
    die $S0
  L1:
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

