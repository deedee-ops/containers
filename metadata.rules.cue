#Spec: {
	app:  #NonEmptyString
	base: bool
	testMuteCmd: bool
	channels: [...#Channels]
}

#Channels: {
	name: #NonEmptyString
  "renovate::dataSource"?: string
  "renovate::depName"?: string
  "renovate::versioning"?: string
	baseimgversion?: string
	version: #NonEmptyString
	platforms: [...#AcceptedPlatforms]
}

#NonEmptyString:           string & !=""
#AcceptedPlatforms:        "linux/amd64" | "linux/arm64"
