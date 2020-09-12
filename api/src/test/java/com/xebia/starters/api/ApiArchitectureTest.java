package com.xebia.starters.api;

import com.github.xebia.archunit.AbstractArchitectureTests;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import com.xebia.starters.Application;
import com.xebia.starters.domain.Entity;

class ApiArchitectureTest extends AbstractArchitectureTests {


    public ApiArchitectureTest() {
        super(new ClassFileImporter()
                        .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
                        .importPackagesOf(Application.class),
                new String[]{Entity.class.getPackage().getName()},
                "com.xebia.starters.(*service).domain",
                Application.class.getPackage().getName(),
                "com.xebia.starters.(*)..",
                new String[]{"Dto"},
                new String[]{"Util", "Utils"});

    }
}
