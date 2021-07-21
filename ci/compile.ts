import {Glob}  from 'glob'
import * as fs from 'fs'

process.env.NEXT_VERSION = process.argv[2] || "0.0.0"
const getFileContents = (filePath: string): Promise<Buffer> => {
    return new Promise((resolve, reject) => {
        fs.readFile(filePath, (err, contents) => {
            if (err) return err;
            resolve(contents)
        })
    })
}

const outDir = process.argv[3] || './dist'

type Context = "client" | "server" | "shared"

class LuaBuilder {

    constructor(public readonly contexts: Context[]) {}

    public compile(): Promise<void> {
        return new Promise(async (resolve, reject) => {
            for(const context of this.contexts) {
                const contextBuff = await this.getContextBuffer(context)
                await this.writeContext(context, contextBuff)
            }
            fs.readFile(`./src/fxmanifest.lua`, 'utf8', (err, manifest) => {
                const newManifest = manifest.replace(/^(version )'(.*)'$/gm, `$1 '${process.env.NEXT_VERSION || '0.0.0'}'`)
                fs.writeFile(`${outDir}/fxmanifest.lua`, newManifest, () => {
                    resolve()
                })
            })
        })
    }

    private getContextBuffer(context: Context): Promise<Buffer> {
        return new Promise((resolve, reject) => {
            const glob = new Glob(`./src/${context}/**/*.lua`, {absolute: true}, async (err, matches) => {
                let output: Buffer[] = []
                for (const file of matches) {
                    if(file.indexOf("fxmanifest.lua") > -1) continue;
                    const contents = await getFileContents(file)
                    output.push(contents, Buffer.from("\n\n", "utf-8"))
                }
                resolve(Buffer.concat(output))
            })
        })
    }

    private writeContext(context: string, buff: Buffer): Promise<void> {
        return new Promise((resolve, reject) => {
            fs.mkdir(outDir, () => {
                fs.mkdir(`${outDir}/${context}`, () => {
                    fs.writeFile(`${outDir}/${context}/${context}.lua`, buff, (err) => {
                        resolve()
                    })
                })
            })
        })
    }
}

const builder = new LuaBuilder(["server"])
builder.compile().then(() => {
    fs.copyFile("./src/server/path.js", "./dist/server/path.js", () => {

    })
})
