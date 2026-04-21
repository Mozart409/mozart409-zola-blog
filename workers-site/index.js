// This worker serves the static files from the Zola site
import { getAssetFromKV } from "@cloudflare/kv-asset-handler";

export default {
  async fetch(request, env, ctx) {
    try {
      return await getAssetFromKV(request, {
        ASSET_NAMESPACE: env.__STATIC_CONTENT,
        ASSET_MANIFEST: env.__STATIC_CONTENT_MANIFEST,
      });
    } catch (e) {
      return new Response("Not Found", { status: 404 });
    }
  },
};
