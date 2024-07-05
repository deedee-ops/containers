#Spec: {
	app:  #NonEmptyString
	base: bool
	insecure?: bool
	testMuteCmd: bool
	channels: [...#Channels]
}

#Channels: {
	name: #NonEmptyString
  "renovate::dataSource"?: string
  "renovate::depName"?: string
  "renovate::packageName"?: string
  "renovate::versioning"?: string
	baseimgversion?: string
	metavar?: string
	version: #NonEmptyString
	platforms: [...#AcceptedPlatforms]
}

#NonEmptyString:           string & !=""
#AcceptedPlatforms:        "linux/amd64" | "linux/arm64"
