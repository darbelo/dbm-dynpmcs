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
    $P3 = split ' ', 'src/pmc/gdbmhash.pmc'
    $P2['gdbmhash'] = $P3
    $P0['dynpmc'] = $P2

    #test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0

    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'libdetect' :anon
    .param pmc kv :slurpy :named
    # TODO detect which libraries are available and build the proper one.
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

