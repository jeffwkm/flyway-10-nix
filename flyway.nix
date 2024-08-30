{ lib, stdenv, fetchurl, jre_headless, makeWrapper, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "flyway";
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
    mkdir -p $out/bin $out/share/flyway
    cp -r lib conf drivers licenses README.txt $out/share/flyway
    mkdir -p $out/share/flyway/jars
    lib="$out/share/flyway/lib"
    makeWrapper "${jre_headless}/bin/java" $out/bin/flyway \
      --add-flags "-Djava.security.egd=file:/dev/../dev/urandom" \
      --add-flags "-classpath '$lib/*:$lib/aad/*:$lib/plugins/*:$lib/oracle_wallet/*:$lib/flyway/*:$lib/drivers/*:$lib/drivers/gcp/*:$lib/drivers/cassandra/*'" \
      --add-flags "org.flywaydb.commandline.Main" \
      --add-flags "-jarDirs='$out/share/flyway/jars'"
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
