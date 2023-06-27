/*
 * Copyright 2023 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.cr.smoketest.support;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * Output from an application.
 *
 * @author Andy Wilkinson
 */
public class Output {

	private final Path path;

	private Output(Path path) {
		this.path = path;
	}

	public List<String> lines() {
		try {
			return Files.readAllLines(this.path);
		}
		catch (IOException ex) {
			throw new RuntimeException();
		}
	}

	public static Output current() {
		String property = System.getProperty("org.springframework.cr.smoketest.standard-output");
		if (property == null) {
			throw new IllegalStateException(
					"Standard output is not available as org.springframework.cr.smoketest.standard-output "
							+ "system property has not been set");
		}
		return new Output(new File(property).toPath());
	}

}
