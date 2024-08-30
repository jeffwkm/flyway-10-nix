{ lib, stdenv, fetchurl, jre_headless, makeWrapper, testers, libGlob ? "*"
, driversGlob ? "*", suffix ? null }:

stdenv.mkDerivation (finalAttrs: {
  pname = (if isNull suffix then "flyway" else "flyway-${suffix}");
  version = "10.17.2";
  src = fetchurl {
    url =
      "mirror://maven/org/flywaydb/flyway-commandline/${finalAttrs.version}/flyway-commandline-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-AK1eluVI4+Hu7ARWgTas0CiKZU14i5uaDtGqh6ewC0g=";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    lib="$out/share/flyway/lib"
    drivers="$out/share/flyway/drivers"

    mkdir -p $out/bin $lib $drivers

    cp -r lib/${libGlob} $lib
    cp -r drivers/${driversGlob} $drivers

    makeWrapper "${jre_headless}/bin/java" $out/bin/flyway \
      --add-flags "-Djava.security.egd=file:/dev/../dev/urandom" \
      --add-flags "-classpath '$lib/*:$lib/aad/*:$lib/flyway/*:$lib/oracle_wallet/*:$drivers/*:$drivers/gcp/*:$drivers/cassandra/*'" \
      --add-flags "org.flywaydb.commandline.Main"
  '';
  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };
  meta = with lib; {
    description =
      "Evolve your Database Schema easily and reliably across all your instances";
    longDescription = ''
      The Flyway command-line tool is a standalone Flyway distribution.
      It is primarily meant for users who wish to migrate their database from the command-line
      without having to integrate Flyway into their applications nor having to install a build tool.

      This package is only the Community Edition of the Flyway command-line tool.
    '';
    mainProgram = "flyway";
    downloadPage = "https://github.com/flyway/flyway";
    homepage = "https://flywaydb.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
})
