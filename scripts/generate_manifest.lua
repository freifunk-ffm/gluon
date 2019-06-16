dofile('scripts/common.inc.lua')

assert(env.GLUON_IMAGEDIR)
assert(env.GLUON_TARGETSDIR)


local target = arg[1]

dofile(env.GLUON_TARGETSDIR..'/'..target)


local function strip(s)
	return string.gsub(s, '\n$', '')
end

local function generate_line(model, dir, filename, filesize)
	local exists = pcall(exec, {'test', '-e', dir..'/'..filename})
	if not exists then
		return
	end

	local file256sum = strip(exec_capture {'scripts/sha256sum.sh', dir..'/'..filename})
	local file512sum = strip(exec_capture {'scripts/sha512sum.sh', dir..'/'..filename})

	io.stdout:write(string.format('%s %s %s %s %s\n', model, env.GLUON_RELEASE, file256sum, filesize, filename))
	io.stdout:write(string.format('%s %s %s %s\n', model, env.GLUON_RELEASE, file256sum, filename))
	io.stdout:write(string.format('%s %s %s %s\n', model, env.GLUON_RELEASE, file512sum, filename))
end

local function generate(image)
	local dir, filename = image:dest_name(image.image)
	local exists = pcall(exec, {'test', '-e', dir..'/'..filename})
	if not exists then
		return
	end

	local filesize = strip(exec_capture {'scripts/filesize.sh', dir..'/'..filename})

	generate_line(image.image, dir, filename, filesize)

	for _, alias in ipairs(image.aliases) do
		local aliasdir, aliasname = image:dest_name(alias)
		generate_line(alias, aliasdir, aliasname, filesize)
	end

	for _, alias in ipairs(image.manifest_aliases) do
		generate_line(alias, dir, filename, filesize)
	end
end

for _, image in ipairs(images) do
	if image.subdir == 'sysupgrade' then
		generate(image)
	end
end